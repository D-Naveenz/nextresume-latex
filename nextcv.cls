%%%%%%%%%%%%%%%%%
%% NextCV - v1.1.0 - Naveen Dharmathunga (dasheenaveen@outlook.com)
%% This is an upgraded version of altacv.cls (v1.7.1) written by LianTze Lim.
%% ================================================================================
%% It may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% The latest version of this license is in http://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2003/12/01 or later.
%% ================================================================================
%% Additionally, this derived work is licensed under the MIT License.
%% See LICENSE file in the root directory for more information.
%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nextcv}[2024/07/29 NextCV v1.1.0, The template class for a next generation resume/curriculum vitae.]

\ExplSyntaxOn
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

%% Load ragged2e for better text alignment
\bool_new:N \g_raggedtwoe_bool
\DeclareOption{ragged2e}{\bool_gset_true:N \g_raggedtwoe_bool}

%% Load hyperref for clickable hyperlinks
\bool_new:N \g_withhyper_bool
\DeclareOption{withhyper}{\bool_gset_true:N \g_withhyper_bool}

%% Hide field names in TokenGrid (show only icons)
\bool_new:N \g_fieldnames_bool
\DeclareOption{fieldnames}{\bool_gset_true:N \g_fieldnames_bool}

\ProcessOptions\relax

\LoadClass{article}

% Load Lua support
\RequirePackage{luacode}
%% Make files more 'friendly' with copy-paste etc
\RequirePackage{xparse}

% Set hyperref options before loading the package to avoid duplicate option warnings
\bool_if:NT \g_withhyper_bool {
  \PassOptionsToPackage{colorlinks=true}{hyperref}
}

\RequirePackage{hyperref,hyperxmp,setspace}
\RequirePackage[margin=2cm]{geometry}

\bool_if:NT \g_raggedtwoe_bool {\RequirePackage[newcommands]{ragged2e}}

% Load required packages
\RequirePackage{fontspec}
\RequirePackage{multicol}

% Configure multicols spacing to reduce gaps
\setlength{\multicolsep}{0.5\baselineskip} % this can be adjusted (ex: 0.5\baselineskip plus 0.2\baselineskip minus 0.1\baselineskip)
\setlength{\columnsep}{1.2em}    % Space between columns

\RequirePackage{graphicx}        % For image inclusion and clipping
\RequirePackage{svg}             %  pass svg options to package graphicx
\RequirePackage[export]{adjustbox} % For advanced image adjustments like clipbox
\RequirePackage{xcolor}          % For color definitions (e.g., \color{accent})
\RequirePackage{pgffor}          % For \foreach loops
\RequirePackage{ifthen}          % For conditional logic (optional but useful)
\RequirePackage{accsupp}         % For accessibility support (e.g., screen readers)
\RequirePackage{xfp}             % For floating point math (more reliable than \ifdim)
\RequirePackage{tabularray}      % For the tblr environment (modern table formatting)

% Change the font if you want to, depending on whether you're using xelatex/lualatex
% Here we set Aptos (the default Microsoft font) as the main font for the Next Resume theme
\setmainfont{Aptos}[
  Path           =./fonts/Aptos/,
  Extension      =.ttf,
  UprightFont    =*,
  ItalicFont     =*-Italic,
  BoldFont       =*-Bold,
  BoldItalicFont =*-Bold-Italic,
]

\newfontfamily\headerfont{Montserrat}[
  Path           =./fonts/Montserrat/static/,
  Extension      =.ttf,
  UprightFont    =*-Regular,
  ItalicFont     =*-Italic,
  BoldFont       =*-Bold,
  BoldItalicFont =*-BoldItalic,
]

% Define the default color scheme
\colorlet{accent}{blue!70!black}
\colorlet{emphasis}{black}
\colorlet{heading}{black}
\colorlet{headingrule}{black}
\colorlet{subheading}{emphasis}
\colorlet{body}{black!80!white}
\colorlet{name}{heading}
\colorlet{tagline}{accent}
\colorlet{link}{blue}

% Define styles for markers
\newcommand{\nextItemMarker}{{\small\textbullet}}
\newcommand{\nextRatingMarker}{\nextSVGIcon{circle}}
\newcommand{\nextDateMarker}{\faIcon{calendar}}
\newcommand{\nextLocationMarker}{\textbf{\faIcon{map-marker-alt}}}
\newcommand{\nextCertificateMarker}{\textbf{\faIcon{certificate}}}
\newcommand{\nextProjectLinkMarker}{\faIcon[brands]{github}}
\newcommand{\nextProjectRoleMarker}{\textbf{\faIcon{user}}}
\newcommand{\nextProjectMarker}{\textbf{\faIcon{folder}}}

% Define text styles
\newcommand{\nextNameStyle}[1]{{\Huge\bfseries\color{name}#1}}%
\newcommand{\nextTaglineStyle}[1]{{\large\itshape\color{tagline}#1}}%
\newcommand{\nextPersonalInfoStyle}[1]{{\footnotesize\bfseries#1}}%
\newcommand{\nextHeadingStyle}[1]{{\LARGE\bfseries\color{heading}#1}}%
\newcommand{\nextSubheadingStyle}[1]{{\Large\bfseries\color{heading}#1}}%

% Customize itemize and enumerate environments
\RequirePackage[inline]{enumitem}
\setlist{leftmargin=*,labelsep=0.5em,nosep,itemsep=0.25\baselineskip,after=\vspace{0.25\baselineskip}}
\setlist[itemize]{label=\nextItemMarker}

\RequirePackage{tikz}
\RequirePackage{multirow,tabularx}
\RequirePackage{listofitems} % String splitter
\RequirePackage{array}

\NewDocumentCommand{\nextSVGIcon}{m O{1.2em}}{%
  \begingroup%
  \def\@TexIconPath{./icons/#1.svg}%
  \includesvg[height=#2]{\@TexIconPath}
  \endgroup%
}

%% ============= Personal Info Data Structure (Lua Implementation) =============

% Define boolean values for Lua
\newcommand{\resume@hidefieldnamesvalue}{\bool_if:NT \g_fieldnames_bool { false } \bool_if:NF \g_fieldnames_bool { true }} % Inverted logic for fieldnames option
\newcommand{\resume@withhypervalue}{\bool_if:NT \g_withhyper_bool { true } \bool_if:NF \g_withhyper_bool { false }}

\begin{luacode*}
  -- Load LUA libraries
  TokenGrid = require("next_tokengrid")
  RatingBox = require("next_ratingbox")

  -- Create a new TokenGrid instance for personal info
  next_personal_info = TokenGrid:new("\\resume@hidefieldnamesvalue", "\\resume@withhypervalue")
\end{luacode*}

% This command is a higher-level utility for defining new fields (e.g., email, phone) with associated symbols and optional hyperlink prefixes.
% Added starred mode to create the field with full URL
% \NewInfoField{<fieldname>}{<symbol>}[<hyperlink prefix>] -> (ex: <github symbol> D-Naveenz) 
% \NewInfoField*{<fieldname>}{<symbol>} -> (ex: <github symbol> https://github.com/D-Naveenz)
\NewDocumentCommand{\NewInfoField}{s m m o}{%
  \IfBooleanTF{#1}
    {% Starred version: full URL mode
     \directlua{
       next_personal_info:create_info_field("#2", "\luaescapestring{\unexpanded{#3}}", "fullurl")
     }%
    }
    {% Unstarred version: prefix mode
     \IfValueTF{#4}
       {% With hyperlink prefix
        \directlua{
          next_personal_info:create_info_field("#2", "\luaescapestring{\unexpanded{#3}}", "prefix", "\detokenize{#4}")
        }%
       }
       {% Without hyperlink prefix  
        \directlua{
          next_personal_info:create_info_field("#2", "\luaescapestring{\unexpanded{#3}}", "noprefix")
        }%
       }%
    }%
}

% Main command to print the personal info fields in a table
\newcommand{\resume@info@printfields}[1]{%
  \directlua{
    next_personal_info:build_grid(#1)
  }
}

% Utility command to clear all fields
\newcommand{\resume@info@clear}
{
  \directlua{
    next_personal_info:clear_fields()
  }
}

%% v1.1.0 declare name variables with default values
\def\@name{}
\def\@jobtitle{}

%% Define field names for accessibility
\newcommand{\datename}{Date}
\newcommand{\locationname}{Location}
\newcommand{\rolename}{Role}
\newcommand{\projectlink}{Project Link}

% Set PDF metadata using hyperref and hyperxmp
% Parameters: <author name> <job title>
\newcommand{\resume@SetMetadata}[2]{%
  % Set up hyperref configuration (combining color setup with metadata)  
  \bool_if:NTF \g_withhyper_bool {
    % Set XMP metadata using hyperxmp with link colors
    \hypersetup{
      linkcolor=link, 
      urlcolor=link,
      pdfauthor={#1},
      pdftitle={#2},
      pdfsubject={Resume~of~#1},
      pdfkeywords={Resume,~CV,~#2,~#1}
    }
  }{
    % Set XMP metadata using hyperxmp only
    \hypersetup{
      pdfauthor={#1},
      pdftitle={#2},
      pdfsubject={Resume~of~#1},
      pdfkeywords={Resume,~CV,~#2,~#1}
    }
  }
}

\ExplSyntaxOff

%% utils
\newenvironment{fullwidth}{%
  \begin{adjustwidth}{}{\dimexpr-\marginparwidth-\marginparsep\relax}
}{%
  \end{adjustwidth}
}

\newcommand{\cvsectionfont}{\LARGE\bfseries}
\newcommand{\cvsubsectionfont}{\large\bfseries}

% The default section environment with optional icon
\NewDocumentEnvironment{nextsection}{m O{}}{%
  \par\vspace{1.5\baselineskip}\noindent % Add vertical space
  % Add the section title in a table to align with the icon if provided
  \IfValueTF{#2}{%
    \begin{tblr}{stretch = 0, colspec = {Q[h,l]l}, colsep=0.4em}%
      #2 & \nextHeadingStyle{#1}\\
    \end{tblr}%
  }{%
    \nextHeadingStyle{\MakeUppercase{#1}}
  }%
  % Add a horizontal rule rest of the line
  \hspace{2ex}{\color{headingrule}\hrulefill}
  \par\vspace{0.5\baselineskip} % Add some space after the section heading
}{%
  \par
}%

% Resume Header Environment
\NewDocumentEnvironment{resumeheader}{ O{3} }{%
  % Support for multiple photos
  \newlength{\resume@profilephoto@width}
  \newlength{\resume@profilephoto@hspace}
  \def\resume@profilephoto{}

  % Helper command for making a photo in resumeheader
  \newcommand{\resume@makeaphoto}[2]{%
    \begin{minipage}[c]{##1}%
      \begin{tikzpicture}%
        \clip (0,0) circle (0.5\linewidth); % Clip using half of #1 (radius)
        \node at (0,0) {\includegraphics[width=\linewidth]{##2}}; % Set image width to #1
        \draw[line width=3pt, color=accent] (0,0) circle (0.47\linewidth); % Inner border
        \draw[line width=2pt, color=headingrule] (0,0) circle (0.49\linewidth); % Outer border
      \end{tikzpicture}%
    \end{minipage}%
  }

  % Photo command for use within resumeheader environment
  \NewDocumentCommand{\profilephoto}{m m O{1cm}}{%
    \setlength{\resume@profilephoto@hspace}{##3}%
    \setlength{\resume@profilephoto@width}{##2}%
    \def\resume@profilephoto{\resume@makeaphoto{\resume@profilephoto@width}{##1}}%
  }

  % Personal Information
  \newcommand{\name}[1]{\def\@name{##1}}
  \newcommand{\jobtitle}[1]{\def\@jobtitle{##1}}

  % Define profile info fields
  \NewInfoField{email}{\nextSVGIcon{email}}[mailto:]%
  \NewInfoField{mailaddress}{\nextSVGIcon{mail}}%
  \NewInfoField{phone}{\nextSVGIcon{call}}[tel:]%
  \NewInfoField{homepage}{\nextSVGIcon{internet}}[https://]%
  \NewInfoField{twitter}{\nextSVGIcon{twitter}}[https://x.com/]%
  \NewInfoField{linkedin}{\nextSVGIcon{linkedin}}[https://linkedin.com/in/]%
  \NewInfoField{github}{\nextSVGIcon{github}}[https://github.com/]%
  \NewInfoField{medium}{\nextSVGIcon{medium}}[https://medium.com/]%

  % Hyperref configuration is set in AtBeginDocument hook
  \resume@SetMetadata{\@name}{\@jobtitle}

  \begingroup
}{%
  \resume@profilephoto\hfill%
  \begin{minipage}{\dimexpr\linewidth-\resume@profilephoto@width-\resume@profilephoto@hspace\relax}%
    \raggedright%
    {\nextNameStyle{\@name}\par}
    \medskip
    {\nextTaglineStyle{\@jobtitle}\par}
    \medskip
    {\nextPersonalInfoStyle{\resume@info@printfields{#1}}\par}
  \end{minipage}\par
  \vspace{12pt}
  \endgroup
}

% Resume Skills Environment. Use \columnbreak to break columns manually.
% Parameters: [number of columns (default 1)]
\NewDocumentEnvironment{nextskills}{ O{1} }{%
  \directlua{rating_box = RatingBox:new("accent", "body!30", 5)}%

  % Add a skill with weighted rating
  % Use accsupp so that the actual numeric value is copied/pasted and also support 0.5, 1.5, 2.5, 3.5, 4.5
  % Parameters: <skill name> <rating out of 5>
  \newcommand{\weightedskill}[2]{%
    \def\skillname{\color{emphasis}##1}%
    \def\rating{%
      \directlua{tex.sprint(rating_box:render_rating(##2))}%
    }%
    \noindent%
    \begin{tblr}{width=\dimexpr\columnwidth-2em\relax, colspec={ l X[l] Q[h,r] }, colsep=0pt}%
      \skillname & & \rating \\
    \end{tblr}%
    \par\vspace{1ex}%
  }

  %\hspace{1em}% Add space between markers (adjust the value as needed)

  % Skill Section Environment
  \NewDocumentEnvironment{skillsection}{ m O{1em} }{%
    % Prevent column breaks within skill sections
    \begin{minipage}[t]{\dimexpr\columnwidth-3pt\relax} % [t] for top alignment
      {\large\textcolor{emphasis}{\bfseries-- \MakeUppercase{##1}}}\par%
      \smallskip
      \def\contentwidth{\dimexpr\linewidth-##2\relax}%
      \hfill
      \begin{minipage}[t]{\contentwidth} % [t] for top alignment
        \RaggedRight%
  }{%
      \end{minipage}
    \end{minipage}
    \par\medskip%
  }%

  \begin{nextsection}{Skills}[\nextSVGIcon{email}]%
    \begin{multicols}{#1}%
}{%
    \end{multicols}%
  \end{nextsection}%
}%

\newcommand{\cvsubsection}[1]{%
  \smallskip%
  {\color{subheading}\cvsubsectionfont{#1}\par}\medskip
}

\newcommand{\cvevent}[4]{%
  {\large\bfseries\color{emphasis}#1\par}
  \smallskip\normalsize
  \ifstrequal{#2}{}{}{
    \textbf{\color{subheading}#2}\par
    \smallskip}
  \ifstrequal{#3}{}{}{%
    {\small\color{emphasis}\makebox[0.5\linewidth][l]%
        {\BeginAccSupp{method=pdfstringdef,ActualText={\datename:}}\nextDateMarker\EndAccSupp{}%
          ~\normalfont#3}%
      }}%
  \ifstrequal{#4}{}{}{%
    {\small\color{emphasis}\makebox[0.5\linewidth][r]%
        {\BeginAccSupp{method=pdfstringdef,ActualText={\locationname:}}\nextLocationMarker\EndAccSupp{}%
          ~\normalfont#4}%
      }}\par
  \medskip\normalsize
}

\newcolumntype{Y}{>{\raggedright\arraybackslash}X}
\newcommand{\cvproject}[5]{%
  %% Header
  {
      \setsepchar{,}%  
      \readlist*\titlelist{#1}%
      %% Check tiltlelist has more than 1 elements
      \ifnum\titlelistlen>1
        \begin{tabularx}{\columnwidth}{@{}l | Y@{}}
          \large\textcolor{subheading}{\textbf{\titlelist[1]}} & \textcolor{emphasis}{\textbf{\titlelist[2]}} \\
        \end{tabularx}\par
      \else
        \large\textcolor{emphasis}{\textbf{#1}}\par
      \fi
      \smallskip\normalsize
      \let\titlelist\relax
    }
    %% Role
    {%
      {\small\color{emphasis}\makebox[0.5\linewidth][l]%
          {\BeginAccSupp{method=pdfstringdef,ActualText={\rolename:}}\nextProjectRoleMarker\EndAccSupp{}%
            ~\normalfont\ifstrequal{#2}{}{Personal Project}{#2}}%
        }%
    }%
  %% Project Link
  \ifstrequal{#3}{}{}{%
    % The parsing-separator⟨delimiter⟩“/” is reserved by default for nested lists
    %  To set “/” as the ⟨parsing-separator⟩ for a simple list, it is necessary, using the optional argument
    \setsepchar[,]{/}%
    \readlist*\urllist{#3}%
    {\small\color{emphasis}\makebox[0.5\linewidth][r]%
      {\BeginAccSupp{method=pdfstringdef,ActualText={\projectlink:}}\nextProjectLinkMarker\EndAccSupp{}%
        ~\normalfont\href{#3}{\textbf{GitHub: }\urllist[-1]}}%
    }%
    \let\urllist\relax
  }\par\smallskip
  %% Description
  \ifstrequal{#4}{}{}{%
    \smallskip
    \small{#4}
  }
  %% Technologies
  \ifstrequal{#5}{}{}{%
    \smallskip
    \textcolor{emphasis}{\textbf{Technologies: }} #5
  }
  \medskip\normalsize
}

\newcommand{\cvsubproject}[5]{%
  \smallskip
  \begin{spacing}{1.5}
    {%
      \small\color{emphasis}%
      \begin{tabularx}{\columnwidth}{@{}m{1.2em} @{\hspace{1ex}} Y@{}}
        %% Project
        \BeginAccSupp{method=pdfstringdef,ActualText={\detokenize{[project icon]}}}\nextProjectMarker\EndAccSupp{}  & \textbf{Project: }#1                                   \\
        %% Role
        \BeginAccSupp{method=pdfstringdef,ActualText={\detokenize{[role icon]}}}\nextProjectRoleMarker\EndAccSupp{} & \textbf{Role: }\ifstrequal{#2}{}{Personal Project}{#2} \\
      \end{tabularx}\par%
      %% Project Link
      \ifstrequal{#3}{}{}
      {%
        % The parsing-separator⟨delimiter⟩“/” is reserved by default for nested lists
        %  To set “/” as the ⟨parsing-separator⟩ for a simple list, it is necessary, using the optional argument
        \setsepchar[,]{/}%
        \readlist*\urllist{#3}%
        \begin{tabularx}{\columnwidth}{@{}m{1.2em} @{\hspace{1ex}} >{\raggedright\arraybackslash}X@{}}
          \BeginAccSupp{method=pdfstringdef,ActualText={\detokenize{[github icon]}}}\nextProjectLinkMarker\EndAccSupp{} & \href{#3}{\textbf{GitHub: }\urllist[-1]} \\
        \end{tabularx}%
        \let\urllist\relax
      }%
    }%
  \end{spacing}
  %% Description
  \ifstrequal{#4}{}{}{%
    \smallskip
    \small{#4}
  }
  %% Technologies
  \ifstrequal{#5}{}{}{%
    \smallskip
    \textcolor{emphasis}{\textbf{Technologies: }} #5
  }
  \medskip\normalsize
}

% adds accsupp for the icon as well
\newcommand{\cvcert}[3]{%
  \begin{tabularx}{\columnwidth}{@{}p{2em} @{\hspace{1ex}} >{\raggedright\arraybackslash}X@{}}
    \multirow{2}{*}{\Large\color{accent}\BeginAccSupp{method=escape,ActualText={\detokenize{\nextCertificateMarker}: }}\nextCertificateMarker\EndAccSupp{}} & \bfseries\textcolor{emphasis}{#1} \\
                                                                                                                                                        & \small{\href{#2}{#3}}
  \end{tabularx}%
  \smallskip
}

\newcommand{\cvachievement}[3]{%
  \begin{tabularx}{\columnwidth}{@{}p{2em} @{\hspace{1ex}} >{\raggedright\arraybackslash}X@{}}
    \multirow{2}{*}{\Large\color{accent}\BeginAccSupp{method=escape,ActualText={\detokenize{#1}: }}#1\EndAccSupp{}} & \bfseries\textcolor{emphasis}{#2} \\
                                                                                                                    & #3
  \end{tabularx}%
  \smallskip
}

\newcommand{\cvtag}[1]{%
  \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep =0.75ex,text height=1.5ex,text depth=.25ex]{#1};
}

\newcommand{\cvref}[4]{%
  \smallskip
  \textcolor{emphasis}{\textbf{#1}}\par
  \textbf{\color{subheading}#2}\par
  \begin{description}[font=\color{accent},style=multiline,leftmargin=1.35em,align=left]
    \item[\small\normalfont\textbf{\faIcon{briefcase}}] #3
    \item[\small\normalfont\faIcon{at}] #4
  \end{description}
  %   \medskip
}

\newenvironment{cvcolumn}[1]{\begin{minipage}[t]{#1}\raggedright}{\end{minipage}}

\AddToHook{begindocument/before}{%
  \pagestyle{empty}
  \color{body}
  \raggedright
}
