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
\ProcessOptions\relax

\LoadClass{article}

% Load the Next Theme Package
\RequirePackage{nexttheme}

%% file more 'friendly' with copy-paste etc
\RequirePackage{xcolor,accsupp,xparse,hyperref,hyperxmp,setspace}
\RequirePackage[margin=2cm]{geometry}

\bool_if:NT \g_raggedtwoe_bool {\RequirePackage[newcommands]{ragged2e}}

\bool_if:NT \g_withhyper_bool {
  \AtEndPreamble{\hypersetup{colorlinks=true, linkcolor=link, urlcolor=link}}
}

\RequirePackage{tikz}
\RequirePackage{dashrule}
\RequirePackage{multirow,tabularx}
\RequirePackage{graphicx}
\RequirePackage{adjustbox}
\RequirePackage{listofitems} % String splitter
\RequirePackage{array}

%% ============= Personal Info Data Structure (Lua Implementation) =============
\RequirePackage{luacode}

% Load the Lua module and create an instance for personal info management
\directlua{
  local TokenGrid = require('next_tokengrid')
  next_personal_info = TokenGrid:new(true, \bool_if:NTF \g_withhyper_bool {true}{false})
}

% Main command to print the personal info fields in a table
\NewDocumentCommand{\resume@info@printfields}{m}{%
  \directlua{next_personal_info:build_grid(#1)}%
}

% Utility command to clear all fields
\NewDocumentCommand{\resume@info@clearfields}{}{%
  \directlua{next_personal_info:clear_fields()}%
}

% This command is a higher-level utility for defining new fields (e.g., email, phone) with associated symbols and optional hyperlink prefixes.
% Added starred mode to create \printinfo with full URL
% \NewInfoField{<fieldname>}{<symbol>}[<hyperlink prefix>]
% \NewInfoField*{<fieldname>}{<symbol>}
\NewDocumentCommand{\NewInfoField}{s m m o}{%
  % Create the field directly via Lua - no need for complex LaTeX logic
  \directlua{
    local field_name = '#2'
    local symbol = [==[#3]==]
    local custom_hyper = \IfBooleanTF{#1}{true}{false}
    local hyperlink_prefix = \tl_if_blank:nTF {#4} { '' } { [==[#4]==] }
    next_personal_info:create_info_field(field_name, symbol, custom_hyper, hyperlink_prefix)
  }%
}
%% ============= Personal Info Data Structure (Lua Implementation) =============

%% Declare contact info fields
\NewInfoField{email}{\faIcon{at}}[mailto:]
\NewInfoField{mailaddress}{\faIcon{envelope}}
\NewInfoField{phone}{\textbf{\faIcon{phone}}}[tel:]
\NewInfoField{homepage}{\textbf{\faIcon{globe}}}[https://]
\NewInfoField{twitter}{\faIcon{x-twitter}}[https://x.com/]  %% twitter -> x
\NewInfoField{linkedin}{\faIcon{linkedin}}[https://linkedin.com/in/]
\NewInfoField{github}{\faIcon{github}}[https://github.com/]
\NewInfoField{medium}{\faIcon{medium}}[https://medium.com/]

%% v1.1.0 declare name variables
\newcommand{\name}[1]{\def\@name{#1}}
\newcommand{\jobtitle}[1]{\def\@jobtitle{#1}}

%% v1.1.0 Set XMP metadata using hyperxmp
\AtBeginDocument{%
  \hypersetup{
    pdfauthor={\@name},
    pdftitle={\@jobtitle},
    pdfsubject={Resume~of~\@name},
    pdfkeywords={Resume, CV, \@jobtitle, \@name},
    pdfcontactemail={\csname email_data\endcsname},
    pdfcontactphone={\csname phone_data\endcsname},
    pdflicenseurl={https://creativecommons.org/licenses/by/4.0/},
    pdfcopyright={Copyright~\textcopyright{}~\the\year{}~\@name.~All~rights~reserved.},
  }
}
\ExplSyntaxOff

%% utils
\newcommand{\divider}{\textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}\medskip}

\newenvironment{fullwidth}{%
  \begin{adjustwidth}{}{\dimexpr-\marginparwidth-\marginparsep\relax}}
    {\end{adjustwidth}}

\newcommand{\cvsectionspace}{\vspace{20pt}}

% Support for multiple photos
\newlength{\cv@profilephoto@width}
\newlength{\cv@profilephoto@hspace}
\def\cv@profilephoto{}
\setlength{\cv@profilephoto@hspace}{1cm}

\newcommand{\@makeaphoto}[2]{%
  \begin{minipage}[c]{#1}
    \begin{tikzpicture}
      \clip (0,0) circle (0.5\linewidth); % Clip using half of #1 (radius)
      \node at (0,0) {\includegraphics[width=\linewidth]{#2}}; % Set image width to #1
      \draw[line width=3pt, color=accent] (0,0) circle (0.47\linewidth); % Inner border
      \draw[line width=2pt, color=headingrule] (0,0) circle (0.49\linewidth); % Outer border
    \end{tikzpicture}
  \end{minipage}
}

\newcommand{\photo}[2]{%
  \setlength{\cv@profilephoto@width}{#1}
  \def\cv@profilephoto{\@makeaphoto{\cv@profilephoto@width}{#2}}
}

\newcommand{\namefont}{\Huge\bfseries}
\newcommand{\taglinefont}{\large\bfseries}
\newcommand{\personalinfofont}{\footnotesize\bfseries}
\newcommand{\cvsectionfont}{\LARGE\bfseries}
\newcommand{\cvsubsectionfont}{\large\bfseries}

\newcommand{\makecvheader}{%
  \begingroup
  \cv@profilephoto\hfill%
  \begin{minipage}{\dimexpr\linewidth-\cv@profilephoto@width-\cv@profilephoto@hspace\relax}%
    \raggedright%
    {\namefont\color{name}\MakeUppercase{\@name}\par}
    \medskip
    {\taglinefont\color{tagline}\@jobtitle\par}
    \medskip
    {\personalinfofont\cv@info@printfields{4}\par}
  \end{minipage}\par
  \vspace{12pt}
  \divider%
  \endgroup\smallskip%
}

\newcommand{\cvsection}[2][]{%
\nointerlineskip\bigskip%
\ifstrequal{#1}{}{}{\marginpar{\vspace*{\dimexpr1pt-\baselineskip}\raggedright\input{#1}}}%
{\colorbox{headingrule}{\color{heading}\cvsectionfont\MakeUppercase{#2}}}\\[-1.7ex]%
{\color{headingrule}\rule{\linewidth}{2pt}\par}\medskip
}

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
        {\BeginAccSupp{method=pdfstringdef,ActualText={\datename:}}\cvDateMarker\EndAccSupp{}%
          ~\normalfont#3}%
      }}%
  \ifstrequal{#4}{}{}{%
    {\small\color{emphasis}\makebox[0.5\linewidth][r]%
        {\BeginAccSupp{method=pdfstringdef,ActualText={\locationname:}}\cvLocationMarker\EndAccSupp{}%
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
          {\BeginAccSupp{method=pdfstringdef,ActualText={\rolename:}}\cvProjectRoleMarker\EndAccSupp{}%
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
      {\BeginAccSupp{method=pdfstringdef,ActualText={\projectlink:}}\cvProjectLinkMarker\EndAccSupp{}%
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
        \BeginAccSupp{method=pdfstringdef,ActualText={\detokenize{[project icon]}}}\cvProjectMarker\EndAccSupp{}  & \textbf{Project: }#1                                   \\
        %% Role
        \BeginAccSupp{method=pdfstringdef,ActualText={\detokenize{[role icon]}}}\cvProjectRoleMarker\EndAccSupp{} & \textbf{Role: }\ifstrequal{#2}{}{Personal Project}{#2} \\
      \end{tabularx}\par%
      %% Project Link
      \ifstrequal{#3}{}{}
      {%
        % The parsing-separator⟨delimiter⟩“/” is reserved by default for nested lists
        %  To set “/” as the ⟨parsing-separator⟩ for a simple list, it is necessary, using the optional argument
        \setsepchar[,]{/}%
        \readlist*\urllist{#3}%
        \begin{tabularx}{\columnwidth}{@{}m{1.2em} @{\hspace{1ex}} >{\raggedright\arraybackslash}X@{}}
          \BeginAccSupp{method=pdfstringdef,ActualText={\detokenize{[github icon]}}}\cvProjectLinkMarker\EndAccSupp{} & \href{#3}{\textbf{GitHub: }\urllist[-1]} \\
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
    \multirow{2}{*}{\Large\color{accent}\BeginAccSupp{method=escape,ActualText={\detokenize{\cvCertificateMarker}: }}\cvCertificateMarker\EndAccSupp{}} & \bfseries\textcolor{emphasis}{#1} \\
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

\newcommand{\cvtagheader}[1]{
  {\large\textcolor{emphasis}{\bfseries#1}}\par%
  \medskip%
}

\newcommand{\cvtag}[1]{%
  \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep =0.75ex,text height=1.5ex,text depth=.25ex]{#1};
}

% Use accsupp so that the actual numeric value is copied/pasted
%       and also support 0.5, 1.5, 2.5, 3.5, 4.5
\newcommand{\cvskill}[2]{%
{\color{emphasis}#1}\hfill
\BeginAccSupp{method=plain,ActualText={#2}}
\foreach \x in {1,...,5}{%
\ifdimequal{\x pt - #2 pt}{0.5pt}%
%% if true, then print half-filled marker
{\clipbox*{0pt -0.25ex {.5\width} {\totalheight}}{\color{accent}{\cvRatingMarker}}%
\clipbox*{{.5\width} -0.25ex {\width} {\totalheight}}{\color{body!30}{\cvRatingMarker}}%
}%
%% if false, then print marker filled according to rating
{\ifdimgreater{\x bp}{#2 bp}{\color{body!30}}{\color{accent}}{\cvRatingMarker}}%
\hspace{1em}% Add space between markers (adjust the value as needed)
}%
\EndAccSupp{}\par\vspace{1ex}%
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
