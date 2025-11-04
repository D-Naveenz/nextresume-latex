%%%%%%%%%%%%%%%%%
%% NextResume - v2.0.0 - Naveen Dharmathunga (dasheenaveen@outlook.com)
%% ================================================================================
%% It may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% The latest version of this license is in http://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2003/12/01 or later.
%% ================================================================================
%% Additionally, this work is licensed under the MIT License.
%% See LICENSE file in the root directory for more information.
%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nextresume}[2025/11/03 NextResume v2.0.0, The template class for a next generation resume/curriculum vitae.]

\ExplSyntaxOn
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

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
\RequirePackage[margin=1.5cm]{geometry}

%% 4. HYPERREF AND METADATA (Must be loaded early, but after geometry)
% Set hyperref options before loading the package to avoid duplicate option warnings
\ExplSyntaxOn
\bool_if:NT \g_withhyper_bool {
  \PassOptionsToPackage{colorlinks=true}{hyperref}
}
\ExplSyntaxOff

\RequirePackage{hyperref}      % Hyperlinks and PDF features
\RequirePackage{hyperxmp}      % XMP metadata support

%% 5. GRAPHICS AND COLOR PACKAGES
\RequirePackage{xcolor}        % Color definitions (must load before tikz)
\RequirePackage{graphicx}      % Image inclusion
\RequirePackage{tikz}          % TikZ graphics
\usetikzlibrary{calc, arrows.meta, positioning, shapes}          % TikZ libraries for timeline

%% 6. ADVANCED GRAPHICS PACKAGES (After basic graphics)
\RequirePackage{svg}           % SVG support (requires graphicx)

%% 7. TEXT AND LAYOUT PACKAGES
\RequirePackage{array}         % Extended array and tabular
\RequirePackage{multicol}      % Multiple columns
\RequirePackage[inline]{enumitem} % Enhanced lists

%% 8. ACCESSIBILITY AND COMPATIBILITY
\RequirePackage{accsupp}       % Accessibility support for screen readers

%% 9. TEXT ALIGNMENT (Load after other text packages)
\RequirePackage[newcommands]{ragged2e} % Better text alignment

%% 12. LUA LIBRARIES
\begin{luacode*}
  -- Load LUA libraries
  TokenGrid = require("next_tokengrid")
  Utils = require("next_utils")
\end{luacode*}

\ExplSyntaxOn

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

% Define text styles optimized for 10pt base font
\newcommand{\next@style@name}[1]{{\huge\bfseries\color{name}\MakeUppercase{#1}}}
\newcommand{\next@style@tagline}[1]{{\large\itshape\color{tagline}#1}}
\newcommand{\next@style@info}[1]{{\footnotesize\bfseries#1}}
\newcommand{\next@style@heading}[1]{{\headerfont\Large\bfseries\color{heading}#1}}
\newcommand{\next@style@timelinedate}{\footnotesize\color{emphasis}}

% Configure itemize marker (enumitem already loaded above)
\setlist[itemize]{label=\nextItemMarker}

% Include an SVG icon from the icons directory
% Usage: \nextSVGIcon{icon_name}[optional_height]
% Parameters:
%   #1 (mandatory) - Name of the SVG file (without .svg extension)
%   #2 (optional) - Height of the icon (default: 1.2em)
% Example: \nextSVGIcon{email}[1.5em]
\NewDocumentCommand{\nextSVGIcon}{m O{1.2em}}{%
  \begingroup%
  \def\@TexIconPath{./icons/#1.svg}%
  \includesvg[height=#2]{\@TexIconPath}
  \endgroup%
}

% Define styles for markers
\newcommand{\nextItemMarker}{{\small\textbullet}}

% SVG-based markers
\def\nextProfileMarker{\nextSVGIcon{person}[1.5em]}%
\def\nextSkillMarker{\nextSVGIcon{settings}[1.5em]}%
\def\nextExperienceMarker{\nextSVGIcon{briefcase}[1.5em]}%
\def\nextProjectsMarker{\nextSVGIcon{code}[1.5em]}%
\def\nextEducationMarker{\nextSVGIcon{college}[1.5em]}%
\def\nextVolunteeringMarker{\nextSVGIcon{heart}[1.5em]}%
\def\nextCertificatesMarker{\nextSVGIcon{tick}[1.5em]}%
\def\nextStrengthsMarker{\nextSVGIcon{star}[1.5em]}%
\def\nextProjectLinkMarker{\nextSVGIcon{github}[1em]}%

%% ============= Personal Info Data Structure (Lua Implementation) =============

% Define boolean values for Lua
\newcommand{\resume@hidefieldnamesvalue}{\bool_if:NT \g_fieldnames_bool { false } \bool_if:NF \g_fieldnames_bool { true }} % Inverted logic for fieldnames option
\newcommand{\resume@withhypervalue}{\bool_if:NT \g_withhyper_bool { true } \bool_if:NF \g_withhyper_bool { false }}

\begin{luacode*}
  -- Create a new TokenGrid instance for personal info
  -- Convert string boolean values to actual Lua booleans
  local hideFieldNames = "\resume@hidefieldnamesvalue" == "true"
  local withhyper = "\resume@withhypervalue" == "true"
  next_personal_info = TokenGrid:new(hideFieldNames, withhyper)
\end{luacode*}

% Define new personal information fields with icons and optional hyperlinks
% Usage:
%   \NewInfoField{fieldname}{symbol}[hyperlink_prefix]  - Creates field with prefix hyperlinks
%   \NewInfoField*{fieldname}{symbol}                   - Creates field where input is full URL
%
% Parameters:
%   * (optional)     - Starred version treats user input as complete URL
%   #2 (mandatory)   - Field name (used as command name, e.g., "email" creates \email command)
%   #3 (mandatory)   - Symbol/icon to display (typically \nextSVGIcon{...})
%   #4 (optional)    - Hyperlink prefix (e.g., "mailto:", "https://github.com/")
%
% Examples:
%   \NewInfoField{email}{\nextSVGIcon{email}}[mailto:]          % Creates \email{user@domain.com}
%   \NewInfoField{github}{\nextSVGIcon{github}}[https://github.com/]  % Creates \github{username}
%   \NewInfoField*{website}{\nextSVGIcon{internet}}             % Creates \website{https://full.url.com}
%
% The created commands will automatically generate hyperlinks when [withhyper] class option is used.
\NewDocumentCommand{\NewInfoField}{s m m o}{%
  \IfBooleanTF{#1}
    {% Starred version: full URL mode
      \directlua{next_personal_info:create_info_field("#2", "\luaescapestring{\unexpanded{#3}}", "fullurl")}%
    }{% Unstarred version: prefix mode
      \IfValueTF{#4}{% With hyperlink prefix
        \directlua{
          next_personal_info:create_info_field("#2", "\luaescapestring{\unexpanded{#3}}", "prefix", "\detokenize{#4}")
        }%
      }{% Without hyperlink prefix  
        \directlua{
          next_personal_info:create_info_field("#2", "\luaescapestring{\unexpanded{#3}}", "noprefix")
        }%
      }%
    }%
}

% Main command to print the personal info fields in a table
\newcommand{\resume@info@printfields}[1]{%
  \directlua{next_personal_info:build_grid(#1)}
}

% Utility command to clear all fields
\newcommand{\resume@info@clear}{%
  \directlua{
    next_personal_info:clear_fields()
  }
}

%% v1.1.0 declare name variables with default values
\def\@name{}
\def\@jobtitle{}

% Set PDF metadata using hyperref and hyperxmp
% Parameters: <author name> <job title>
% Set PDF metadata using hyperref
% Parameters: #1 = author name, #2 = job title
\newcommand{\resume@SetMetadata}[2]{%
  % Set up hyperref configuration with PDF metadata only
  \hypersetup{
    pdfauthor={#1},
    pdftitle={Resume~-~#1},
    pdfsubject={Resume~of~#1~-~#2},
    pdfkeywords={Resume,~Curriculum~Vitae,~CV,~#1,~#2},
    pdfcreator={NextResume~v2.0.0},
    pdfproducer={LaTeX~with~NextResume~class}
  }
}

\ExplSyntaxOff

%% ============================================================================
%% Header Environment
%% ============================================================================

% Resume Header Environment
\NewDocumentEnvironment{resumeheader}{ O{3} }{%
  % Support for multiple photos
  \newlength{\resume@profilephoto@width}
  \newlength{\resume@profilephoto@hspace}
  \setlength{\resume@profilephoto@width}{0pt}% Initialize to zero
  \setlength{\resume@profilephoto@hspace}{0pt}% Initialize to zero
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

  \begingroup
}{%
  % Set PDF metadata after name and jobtitle have been defined
  \resume@SetMetadata{\@name}{\@jobtitle}
  
  \resume@profilephoto\hfill%
  \begin{minipage}{\dimexpr\linewidth-\resume@profilephoto@width-\resume@profilephoto@hspace\relax}%
    \raggedright%
    {\next@style@name{\@name}\par}
    \medskip
    {\next@style@tagline{\@jobtitle}\par}
    \medskip
    {\next@style@info{\resume@info@printfields{#1}}\par}
  \end{minipage}\par
  \vspace{6pt}
  \endgroup
}

%% ============================================================================
%% Section Environment
%% ============================================================================

% The default section environment with optional icon
\NewDocumentEnvironment{nextsection}{m O{}}{%
  \par\vspace{1.5\baselineskip}\noindent % Add vertical space
  % Add the section title in a table to align with the icon if provided
  \IfValueTF{#2}{%
    \raisebox{-0.15\height}{#2} \hspace{0.4em} \next@style@heading{#1}
  }{%
    \next@style@heading{#1}
  }%
  % Add a horizontal rule rest of the line
  \hspace{0.8em} {\color{headingrule}\hrulefill}
  \par\vspace{0.5\baselineskip} % Add some space after the section heading
}{%
  \par
}%

%% ============================================================================
%% Skills Environment
%% ============================================================================

% Resume Skills Environment. Use \columnbreak to break columns manually.
% Parameters: [number of columns (default 1)]
\NewDocumentEnvironment{nextskills}{ O{1} }{%
  % Parameters: #1 = rating value (0-5, supports 0.5 increments)
  \NewDocumentCommand{\nextRatingBox}{m}{%
    \BeginAccSupp{method=plain,ActualText={##1}}%
    \begin{tikzpicture}[baseline=-0.5em]
      % Calculate positions using pgfmath like in nexttimeline
      \pgfmathsetmacro{\circlespacing}{0.8}  % Spacing between circles
      \pgfmathsetmacro{\circleradius}{0.2}   % Circle radius (smaller for better fit)
      \pgfmathsetmacro{\ratingvalue}{##1}     % Store rating value
      
      % Loop through 5 circles
      \foreach \i in {1,2,3,4,5} {
        \coordinate (circle\i) at ({(\i-1)*\circlespacing},0);
        
        % Check if this circle should be half-filled
        \pgfmathsetmacro{\halfcheck}{abs(\ratingvalue - (\i - 0.5))}
        \ifdim\halfcheck pt<0.01pt
          % Half-filled circle - use clipping method instead of arcs
          \begin{scope}
            \clip (circle\i) ++(-\circleradius,-\circleradius) rectangle ++(\circleradius,2*\circleradius);
            \fill[accent] (circle\i) circle (\circleradius);
          \end{scope}
          \begin{scope}
            \clip (circle\i) ++(0,-\circleradius) rectangle ++(\circleradius,2*\circleradius);
            \fill[body!30] (circle\i) circle (\circleradius);
          \end{scope}
        \else
          % Full or empty circle
          \pgfmathsetmacro{\fillcheck}{\i > \ratingvalue ? 1 : 0}
          \ifdim\fillcheck pt>0.5pt
            \fill[body!30] (circle\i) circle (\circleradius);
          \else
            \fill[accent] (circle\i) circle (\circleradius);
          \fi
        \fi
      }

      % DEBUG: Draw bounding box (comment out when not debugging)
      % \draw[red, thick] (current bounding box.south west) rectangle (current bounding box.north east);
      % \fill[red] (current bounding box.south west) circle (1pt) node[below left, font=\tiny] {SW};
      % \fill[red] (current bounding box.north east) circle (1pt) node[above right, font=\tiny] {NE};
    \end{tikzpicture}%
    \EndAccSupp{}%
  }

  % Add a skill with weighted rating
  % Use accsupp so that the actual numeric value is copied/pasted and also support 0.5, 1.5, 2.5, 3.5, 4.5
  % Parameters: <skill name> <rating out of 5>
  \newcommand{\weightedskill}[2]{%
    \def\skillname{\color{emphasis}##1}%
    \def\rating{\nextRatingBox{##2}}%

    \noindent\skillname\hfill\rating%
    \par\vspace{1ex}%
  }

  %\hspace{1em}% Add space between markers (adjust the value as needed)

  % Skill Section Environment
  \NewDocumentEnvironment{skillsection}{ m O{1em} }{%
    % Prevent column breaks within skill sections
    \begin{minipage}[t]{\dimexpr\columnwidth-3pt\relax} % [t] for top alignment
      {\normalsize\textcolor{emphasis}{\bfseries-- \MakeUppercase{##1}}}\par%
      \def\contentwidth{\dimexpr\linewidth-##2\relax}%
      \hfill
      \begin{minipage}[t]{\contentwidth} % [t] for top alignment
        \RaggedRight%
  }{%
      \end{minipage}
    \end{minipage}
    \vspace{6pt}%
  }%

  \begin{nextsection}{Skills}[\nextSkillMarker]%
    \begin{multicols}{#1}%
}{%
    \end{multicols}%
  \end{nextsection}%
}%

%% ============================================================================
%% Timeline Environment
%% ============================================================================
% Timeline event command - redefined within timeline environments
% Usage: \nexttimelineevent{date_and_location}{content}
% Parameters:
%   #1 (mandatory) - Date and location information (use \nextDateAndLocation)
%   #2 (mandatory) - Content block (typically contains \nextItemHeading, \nextItemSubheading, etc.)
% 
% This command can only be used within nexttimeline or nexttimeline* environments.
% Example:
%   \nexttimelineevent{\nextDateAndLocation[startdate=2020-01, enddate=2023-12, location={City, State}]}{
%     \nextItemHeading{Job Title}
%     \nextItemSubheading{Company Name}
%     \begin{itemize}
%       \item Achievement or responsibility
%     \end{itemize}
%   }
\newcommand{\nexttimelineevent}[2]{%
  \PackageError{nextresume}{%
    \string\nexttimelineevent\space used outside of timeline environment%
  }{%
    The \string\nexttimelineevent\space command can only be used within %
    nexttimeline or nexttimeline* environments.%
  }%
}

% Counter for timeline events
\newcounter{timelineevent}

% Modern dynamic timeline implementation
\newenvironment{nexttimeline}{%
  \setcounter{timelineevent}{0}
  \def\lastbottom{0}% Initialize bottom position tracker
  
  % Calculate dynamic widths based on available space
  \pgfmathsetmacro{\datewidth}{2.8}% Date column width in cm
  \pgfmathsetmacro{\timelinegap}{0.5}% Gap from center to date (left side)
  \pgfmathsetmacro{\eventgap}{0.8}% Gap from center to event (right side)  
  \pgfmathsetmacro{\timelinethickness}{0.1}% Timeline thickness in cm
  \pgfmathsetmacro{\eventpadding}{0.3}% Internal padding for event box
  \pgfmathsetmacro{\safemargin}{0.2}% Safety margin to prevent overfull boxes
  
  % Calculate available width for event box
  % Total available = \linewidth - date width - gaps - timeline thickness - padding - safety margin
  \pgfmathsetmacro{\availablewidth}{\linewidth/1cm - \datewidth - \timelinegap - \eventgap - \timelinethickness - 2*\eventpadding - \safemargin}
  \pgfmathsetmacro{\eventtextwidth}{\availablewidth - 0.4}% Subtract for borders

  \pgfmathsetmacro{\eventspacing}{0.6}% Spacing between events in cm
  \pgfmathsetmacro{\timelinepadding}{0.4}% Vertical padding above/below timeline
  
  % Declare layers before starting tikzpicture
  \pgfdeclarelayer{background}% For timeline
  \pgfdeclarelayer{circles}% For both big and small circles
  \pgfsetlayers{background,circles,main}%
  \begin{tikzpicture}[
    % These styles apply to ALL elements in this tikzpicture
    event/.style={
      rectangle, 
      fill=body!5, 
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
      font=\next@style@timelinedate
    },
    timeline/.style={
      draw=accent!80, 
      thick, 
      line width=1.2pt
    },
    dot/.style={
      circle,
      fill=accent,
      minimum size=7pt,
      inner sep=0pt
    },
    bigcircle/.style={
      circle,
      draw=accent,
      fill=white,
      thick,
      minimum size=13pt,
      inner sep=0pt
    }
  ]

  % Command to add timeline events
  \renewcommand{\nexttimelineevent}[2]{%
    \stepcounter{timelineevent}%
    
    % For first event, use initial position; for subsequent events, use last bottom minus spacing
    \ifnum\thetimelineevent=1%
      \pgfmathsetmacro{\ypos}{0}%
    \else%
      \pgfmathsetmacro{\ypos}{\lastbottom - \eventspacing}%
    \fi
    
    \coordinate (pos\thetimelineevent) at (0,\ypos);
    
    % Date/location node (left side) - use calculated gap
    \node[date, anchor=north east] (date\thetimelineevent) at ($(pos\thetimelineevent) + (-\timelinegap,0)$) {##1};
    
    % Content node (right side) - use calculated gap
    \node[event, anchor=north west] (event\thetimelineevent) at ($(pos\thetimelineevent) + (\eventgap,0) + (0,0.2cm)$) {##2};
    
    % Draw circles on the circles layer
    \begin{pgfonlayer}{circles}
      % Big circle with white fill covers the timeline
      \node[bigcircle] at (0, 0 |- date\thetimelineevent.center) {};
      % Small dot on top of big circle
      \node[dot] at (0, 0 |- date\thetimelineevent.center) {};
    \end{pgfonlayer}
    
    % Update the bottom position for next event
    % Use the minimum of date and event bottom positions (most negative y-coordinate)
    \pgfpointanchor{date\thetimelineevent}{south}
    \pgfgetlastxy{\tempx}{\datebottom}
    \pgfpointanchor{event\thetimelineevent}{south}
    \pgfgetlastxy{\tempx}{\eventbottom}
    \pgfmathsetmacro{\tempbottom}{min(\datebottom/1cm,\eventbottom/1cm)}
    \xdef\lastbottom{\tempbottom}
  }
}{
  % Draw everything at the end
  \ifnum\thetimelineevent>0%
    % Calculate timeline bounds: from padding above first event to padding below last event
    \pgfmathsetmacro{\timelinetop}{\timelinepadding}
    \pgfmathsetmacro{\timelinebottom}{\lastbottom - \timelinepadding}
    % LAYER 1: Draw timeline on background layer (behind everything)
    \begin{pgfonlayer}{background}
      \draw[timeline] (0,\timelinetop) -- (0,\timelinebottom);
    \end{pgfonlayer}
  \fi
  \end{tikzpicture}
}

% Starred version: Simple table-based timeline with proper row spacing
\newenvironment{nexttimeline*}{%
  % Create proper scoping for command redefinition
  \begingroup
  \vspace{-0.8em} % Cancels out that extra space added by tabular
  % Calculate dynamic widths to match nexttimeline environment
  % Use conditional definitions to avoid redefinition errors
  \@ifundefined{staradatewidth}{\newlength{\staradatewidth}}{}
  \@ifundefined{stareventgap}{\newlength{\stareventgap}}{}
  
  \setlength{\staradatewidth}{3cm}      % Date column width (matches TikZ version)
  \setlength{\stareventgap}{1cm}         % Space between columns (reduced for table version)
  
  % Calculate content width: total width - date width - column gap - safety margin
  \@ifundefined{starcontentwidth}{\newlength{\starcontentwidth}}{}
  \setlength{\starcontentwidth}{\dimexpr\linewidth-\staradatewidth-\stareventgap-1em\relax}

  % Each nexttimelineevent creates its own complete table
  \renewcommand{\nexttimelineevent}[2]{%
    \noindent
    \begin{tabular}[t]{
      @{}                                              % No left padding
      >{\raggedleft\arraybackslash}p{\staradatewidth}  % Right-aligned date column
      @{\hspace{\stareventgap}}                        % Fixed space between columns  
      p{\starcontentwidth}                             % Left-aligned content column
      @{}                                              % No right padding
    }
    {\next@style@timelinedate ##1} & {##2} \\
    \end{tabular}%
    \par\vspace{1em}%
  }%
}{
  \vspace{-1em}% Remove the last vspace from the final timeline event
  \endgroup%
}

%% ============================================================================
%% Certificates Environment
%% ============================================================================

\newenvironment{nextcertificates}{
  % Add a certificate entry within the nextcertificates environment
  % Usage: \nextCertificate{certificate_name}{issuing_organization}{verification_url}
  % 
  % Parameters:
  %   #1 - Name of the certificate or certification
  %   #2 - Issuing organization or authority  
  %   #3 - URL for certificate verification or more information
  %
  % Example: \nextCertificate{AWS Certified Solutions Architect}{Amazon Web Services}{https://aws.amazon.com/certification/}
  \newcommand{\nextCertificate}[3]{%
    \item \bfseries\textcolor{emphasis}{##1 | ##2} \\ \small{\href{##3}{##3}}
  }%

  \begin{nextsection}{Certificates}[\nextCertificatesMarker]%
    \begin{itemize}
}{%
    \end{itemize}%
  \end{nextsection}%
}

% Content formatting commands for timeline entries and sections

% Format the main heading for timeline entries (job titles, project names, degrees)
% Usage: \nextItemHeading{Job Title | Company Name}
% Example: \nextItemHeading{Senior Developer | Tech Corp}
\newcommand{\nextItemHeading}[1]{{\large\bfseries\color{heading}#1}\par}%

% Format the subheading for timeline entries (company names, universities, roles)  
% Usage: \nextItemSubheading{Organization or Role Name}
% Example: \nextItemSubheading{University of Technology}
\newcommand{\nextItemSubheading}[1]{{\normalsize\bfseries\color{subheading}#1}\par}%

% Format technology stack information with automatic "Technologies:" prefix
% Usage: \nextTechstack{comma-separated list of technologies}
% Example: \nextTechstack{React, Node.js, PostgreSQL, AWS}
\newcommand{\nextTechstack}[1]{{\bfseries\color{emphasis}Technologies:~#1}\par}%

%% ============================================================================
%% Utility Commands
%% ============================================================================

\ExplSyntaxOn
% Project Reference Command
% Parameters: 
% - {string} #1 - Repository URL
% - {string} [#2] - Deployment Location (optional)
% Add repository and deployment links to project entries
% Usage: \nextProjectRef{repository_url}[deployment_info]
%
% Parameters:
%   #1 (mandatory) - Full URL to the repository (e.g., GitHub, GitLab)
%   #2 (optional)  - Deployment information or live demo link text
%
% Examples:
%   \nextProjectRef{https://github.com/username/project}[Live Demo]
%   \nextProjectRef{https://gitlab.com/username/project}[AWS Deployment]
%   \nextProjectRef{https://github.com/username/project}
%
% The command automatically extracts the repository name from the URL and creates
% a hyperlink when the [withhyper] class option is enabled.
\NewDocumentCommand{\nextProjectRef}{m O{}}{%
  \def\reponame{\directlua{tex.sprint(Utils.get_repository_name("\luaescapestring{#1}"))}}%
  {
    \normalfont\color{emphasis}
    \raisebox{-0.1\height}{\nextProjectLinkMarker}\hspace{0.5em}\textbf{Repository:}~
    \bool_if:NTF \g_withhyper_bool {\href{#1}{\reponame}}{\reponame}%
    \IfValueTF{#2}{%
      ~\hfill~
      \textbf{Deployment:}~{#2}%
    }{}%
    \par\medskip
  }
}

% Simplified date handling using Lua Utils
% Declare variables for date and location storage
\tl_new:N \l_timelineevent_startdate_tl
\tl_new:N \l_timelineevent_enddate_tl
\tl_new:N \l_timelineevent_location_tl

% Key-value interface for date and location in timeline events
\keys_define:nn {timelineevent/dateandloc} {%
  startdate .tl_set:N = \l_timelineevent_startdate_tl,
  startdate .initial:n = {Present}, % Default to "Present"
  enddate   .tl_set:N = \l_timelineevent_enddate_tl,
  enddate   .initial:n = {Present}, % Default to "Present"
  location  .tl_set:N = \l_timelineevent_location_tl,
  location  .initial:n = {}         % Default to empty
}

% Format date and location information for timeline events
% Usage: \nextDateAndLocation[key=value, ...]
% 
% Supported keys:
%   startdate - Start date in YYYY-MM-DD or YYYY-MM format (default: "Present")
%   enddate   - End date in YYYY-MM-DD or YYYY-MM format (default: "Present")  
%   location  - Location string (default: empty, will not display if empty)
%
% Examples:
%   \nextDateAndLocation[startdate=2020-01, enddate=2023-12, location={San Francisco, CA}]
%   \nextDateAndLocation[startdate=2021-03-15, location={Remote}]
%   \nextDateAndLocation[startdate=2019-06, enddate=Present, location={New York, NY}]
%
% The command automatically parses and formats dates using Lua utilities.
\NewDocumentCommand{\nextDateAndLocation}{ O{} }{%
  \keys_set:nn {timelineevent/dateandloc} {#1}%
  % Parse dates using Lua but handle formatting in LaTeX
  \def\parsedstartdate{\directlua{tex.sprint(Utils.parse_date("\luaescapestring{\tl_use:N \l_timelineevent_startdate_tl}"))}}%
  \def\parsedenddate{\directlua{tex.sprint(Utils.parse_date("\luaescapestring{\tl_use:N \l_timelineevent_enddate_tl}"))}}%
  % Format using LaTeX (easier to debug)
  {\parsedstartdate\ --\ \parsedenddate}%
  \tl_if_empty:NF \l_timelineevent_location_tl {\\{\tl_use:N \l_timelineevent_location_tl}}%
}
\ExplSyntaxOff

% Create styled tags for skills, strengths, or keywords
% Usage: \nextTag{tag_text}
%
% Parameters:
%   #1 - Text to display inside the tag
%
% Example: \nextTag{Problem Solving} \nextTag{Leadership} \nextTag{JavaScript}
%
% Creates rounded rectangular tags with colored borders, commonly used in
% Strengths sections or for highlighting key skills and competencies.
\newcommand{\nextTag}[1]{%
  \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep =0.75ex,text height=1.5ex,text depth=.25ex]{#1};\hspace{0.3em plus 0.1em minus 0.1em}%
}

%% ============================================================================
%% Hooks
%% ============================================================================

\AddToHook{begindocument/before}{%
  \pagestyle{empty}
  \color{body}
  \raggedright
}

% Define helper command for setting hyperlink colors
\ExplSyntaxOn
\newcommand{\resume@sethypercolors}{%
  \bool_if:NT \g_withhyper_bool {
    \hypersetup{
      linkcolor=link,
      urlcolor=link,
      citecolor=link
    }
  }
}
\ExplSyntaxOff

% Set hyperlink colors using a hook that runs after color definitions
\AddToHook{begindocument}{\resume@sethypercolors}
