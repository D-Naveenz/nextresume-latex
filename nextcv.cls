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
\ExplSyntaxOff

\LoadClass{article}

%% ============================================================================
%% PACKAGE LOADING - ORDERED BY PRIORITY AND DEPENDENCIES
%% ============================================================================

%% 1. FOUNDATION PACKAGES (Must load first)
% Lua support - Required for LuaTeX functionality
\RequirePackage{luacode}

% L3 programming layer extensions (xparse is now part of LaTeX kernel as of 2020)
% Note: xparse is loaded automatically in modern LaTeX, but we keep it for compatibility

%% 2. FONT AND ENGINE-SPECIFIC PACKAGES
% Font specification package for XeLaTeX/LuaLaTeX
\RequirePackage{fontspec}

%% 3. GEOMETRY AND PAGE LAYOUT (Before hyperref)
\RequirePackage[margin=2cm]{geometry}

%% 4. HYPERREF AND METADATA (Must be loaded early, but after geometry)
% Set hyperref options before loading the package to avoid duplicate option warnings
\ExplSyntaxOn
\bool_if:NT \g_withhyper_bool {
  \PassOptionsToPackage{colorlinks=true}{hyperref}
}
\ExplSyntaxOff

\RequirePackage{hyperref}      % Hyperlinks and PDF features
\RequirePackage{hyperxmp}      % XMP metadata support
\RequirePackage{setspace}      % Line spacing control

%% 5. GRAPHICS AND COLOR PACKAGES
\RequirePackage{xcolor}        % Color definitions (must load before tikz)
\RequirePackage{graphicx}      % Image inclusion
\RequirePackage{tikz}          % TikZ graphics
\usetikzlibrary{calc, arrows.meta, positioning, shapes}          % TikZ libraries for timeline

%% 6. ADVANCED GRAPHICS PACKAGES (After basic graphics)
\RequirePackage{svg}           % SVG support (requires graphicx)
\RequirePackage[export]{adjustbox} % Advanced image adjustments (requires graphicx)

%% 7. MATH AND CALCULATION PACKAGES
% \RequirePackage{xfp}           % Floating point math (L3 layer - replaces pgfmath for most calculations)

%% 8. TEXT AND LAYOUT PACKAGES
\RequirePackage{array}         % Extended array and tabular (load before tabularx)
\RequirePackage{multirow}      % Multirow table cells
\RequirePackage{tabularx}      % Extended tabular with X columns (requires array)
\RequirePackage{tabularray}    % Modern table formatting (alternative to tabularx)
\RequirePackage{multicol}      % Multiple columns
\RequirePackage[inline]{enumitem} % Enhanced lists

%% 9. UTILITY AND STRING PROCESSING PACKAGES  
\RequirePackage{listofitems}   % String splitting utilities (modern alternative to some ifthen uses)

%% 10. ACCESSIBILITY AND COMPATIBILITY
\RequirePackage{accsupp}       % Accessibility support for screen readers

\ExplSyntaxOn
%% 11. TEXT ALIGNMENT (Load after other text packages)
\bool_if:NT \g_raggedtwoe_bool {\RequirePackage[newcommands]{ragged2e}}

%% ============================================================================
%% PACKAGE CONFIGURATION
%% ============================================================================

% Configure multicols spacing to reduce gaps
\setlength{\multicolsep}{0.5\baselineskip} % this can be adjusted (ex: 0.5\baselineskip plus 0.2\baselineskip minus 0.1\baselineskip)
\setlength{\columnsep}{1.2em}    % Space between columns

% Configure enumitem for consistent list formatting
\setlist{leftmargin=*,labelsep=0.5em,nosep,itemsep=0.25\baselineskip,after=\vspace{0.25\baselineskip}}

%% ============================================================================
%% FONT SETUP (After fontspec is loaded)
%% ============================================================================

% Set Aptos as the main font for the Next Resume theme
\setmainfont{Aptos}[
  Path           =./fonts/Aptos/,
  Extension      =.ttf,
  UprightFont    =*,
  ItalicFont     =*-Italic,
  BoldFont       =*-Bold,
  BoldItalicFont =*-Bold-Italic,
]

% Define Montserrat as header font family
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

% Configure itemize marker (enumitem already loaded above)
\setlist[itemize]{label=\nextItemMarker}

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

% Modern dynamic timeline implementation
% Counter for timeline events
\newcounter{timelineevent}

% Timeline environment with dynamic width calculation
\newenvironment{nexttimeline}{%
    \setcounter{timelineevent}{0}
    \def\lastbottom{0}% Initialize bottom position tracker
    
    % Calculate dynamic widths based on available space
    \pgfmathsetmacro{\datewidth}{2.3}% Date column width in cm
    \pgfmathsetmacro{\timelinegap}{0.5}% Gap from center to date (left side)
    \pgfmathsetmacro{\eventgap}{1}% Gap from center to event (right side)  
    \pgfmathsetmacro{\timelinethickness}{0.1}% Timeline thickness in cm
    \pgfmathsetmacro{\eventpadding}{0.3}% Internal padding for event box
    \pgfmathsetmacro{\safemargin}{0.2}% Safety margin to prevent overfull boxes
    
    % Calculate available width for event box
    % Total available = \linewidth - date width - gaps - timeline thickness - padding - safety margin
    \pgfmathsetmacro{\availablewidth}{\linewidth/1cm - \datewidth - \timelinegap - \eventgap - \timelinethickness - 2*\eventpadding - \safemargin}
    \pgfmathsetmacro{\eventtextwidth}{\availablewidth - 0.4}% Subtract for borders
    
    % Declare layers before starting tikzpicture
    \pgfdeclarelayer{background}% For timeline
    \pgfdeclarelayer{circles}% For both big and small circles
    \pgfsetlayers{background,circles,main}%
    \begin{tikzpicture}[
        % These styles apply to ALL elements in this tikzpicture
        event/.style={
            rectangle, 
            draw=accent!60, 
            fill=body!5, 
            thick,
            minimum width=\availablewidth cm,
            text width=\eventtextwidth cm,
            align=left,
            rounded corners=4pt,
            inner sep=\eventpadding cm
        },
        date/.style={
            text width=\datewidth cm,
            align=right,
            anchor=east,
            font=\small\bfseries\color{accent}
        },
        timeline/.style={
            draw=accent!80, 
            thick, 
            line width=2pt
        },
        dot/.style={
            circle,
            fill=accent,
            minimum size=8pt,
            inner sep=0pt
        },
        bigcircle/.style={
            circle,
            draw=accent,
            fill=white,
            thick,
            minimum size=15pt,
            inner sep=0pt
        }
    ]
    % Initialize timeline bounds tracking
    \def\timelinetop{0.8}% Start above first event (using eventspacing value)
    \def\timelinebottom{-0.8}% Will be updated as events are added
}{
    % Draw everything at the end
    \ifnum\thetimelineevent>0%
        % LAYER 1: Draw timeline on background layer (behind everything)
        \begin{pgfonlayer}{background}
            \draw[timeline] (0,\timelinetop) -- (0,\timelinebottom);
        \end{pgfonlayer}
    \fi
    \end{tikzpicture}
}

% Command to add timeline events
\newcommand{\nexttimelineevent}[2]{%
    \stepcounter{timelineevent}%
    % Calculate position based on previous event's bottom plus spacing
    \pgfmathsetmacro{\eventspacing}{0.8}% Spacing between events in cm
    
    % For first event, use initial position; for subsequent events, use last bottom minus spacing
    \ifnum\thetimelineevent=1%
        \pgfmathsetmacro{\ypos}{0}%
    \else%
        \pgfmathsetmacro{\ypos}{\lastbottom - \eventspacing}%
    \fi
    
    \coordinate (pos\thetimelineevent) at (0,\ypos);
    
    % Date/location node (left side) - use calculated gap
    \node[date, anchor=north east] (date\thetimelineevent) at ($(pos\thetimelineevent) + (-\timelinegap,0)$) {#1};
    
    % Content node (right side) - use calculated gap
    \node[event, anchor=north west] (event\thetimelineevent) at ($(pos\thetimelineevent) + (\eventgap,0)$) {#2};
    
    % Draw circles on the circles layer
    \begin{pgfonlayer}{circles}
        % Big circle with white fill covers the timeline
        \node[bigcircle] at (0, 0 |- date\thetimelineevent.center) {};
        % Small dot on top of big circle
        \node[dot] at (0, 0 |- date\thetimelineevent.center) {};
    \end{pgfonlayer}
    
    % Update the bottom position for next event
    % Use the minimum of date and event bottom positions (most negative y-coordinate)
    \coordinate (temp1) at (date\thetimelineevent.south);
    \coordinate (temp2) at (event\thetimelineevent.south);
    \pgfpointanchor{temp1}{center}
    \pgfgetlastxy{\tempx}{\datebottom}
    \pgfpointanchor{temp2}{center} 
    \pgfgetlastxy{\tempx}{\eventbottom}
    \pgfmathsetmacro{\tempbottom}{min(\datebottom/1cm,\eventbottom/1cm)}
    \xdef\lastbottom{\tempbottom}
    
    % Update timeline bottom to extend below the last event
    \pgfmathsetmacro{\newtimelinebottom}{\tempbottom - \eventspacing}
    \xdef\timelinebottom{\newtimelinebottom}
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
