<a id="readme-top"></a>


<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h3 align="center">NextResume v2.0.0</h3>

  <p align="center">
    A modern, ATS-friendly LaTeX resume class powered by Lua and cutting-edge LaTeX technologies.
    <br />
    <em>The next generation of professional resume creation.</em>
    <br />
    <br />
    <a href="https://github.com/D-Naveenz/NextResume/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/D-Naveenz/NextResume/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a>
      <ul>
        <li><a href="#requirements-and-compilation">Requirements and Compilation</a></li>
        <li><a href="#template-file">Template file</a></li>
        <li><a href="#clickable-info-fields">Clickable Info fields</a></li>/'
        <li><a href="#new-information-fields">New Information Fields</a></li>
        <li><a href="#configurable-colours">Configurable colours</a></li>
        <li><a href="#configurable-fonts">Configurable fonts</a></li>
        <li><a href="#configurable-icons">Configurable icons</a></li>
        <li><a href="#is-this-template-ats-friendly">Is this template ATS-friendly?</a></li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

**NextResume** is a complete ground-up rewrite of a modern LaTeX resume class that leverages cutting-edge LaTeX3 programming, Lua scripting, and contemporary typesetting technologies. Born from the discontinuation of NextCV, this project represents a fundamental reimagining of what a resume template should be in 2025.

### 🎯 **What Makes NextResume Different?**

NextResume isn't just another LaTeX template—it's a **complete typesetting ecosystem** designed for the modern job market:

- **🚀 Future-Proof Technology**: Built with LaTeX3 (L3 programming layer) and LuaLaTeX for maximum performance and flexibility
- **🤖 ATS-Optimized**: Single-column, clean structure designed to pass Applicant Tracking Systems  
- **⚡ Lua-Powered**: Dynamic content generation, intelligent spacing, and advanced text processing
- **🎨 Modern Design**: Clean, professional aesthetics that stand out while remaining readable
- **🔧 Modular Architecture**: Every component is designed for easy customization and extension

<p align="right">(<a href="#readme-top">back to top</a>)</p>



## Why Choose LaTeX for Your Resume?

### 📐 **Unbreakable Layout Integrity**
Ever added a space in Microsoft Word and watched your entire document collapse? LaTeX's sophisticated typesetting engine maintains perfect layout consistency. While Word might panic over a single space, LaTeX gracefully handles complex layouts and gives you gentle warnings instead of breaking your formatting.

### 🔧 **True Modularity & Maintainability**  
- **Version Control Friendly**: Your resume is plain text—track every change with Git
- **Separation of Content & Style**: Focus on your achievements while LaTeX handles the beautiful presentation
- **Consistent Formatting**: Never worry about inconsistent fonts, spacing, or alignment again
- **Professional Typography**: Automatic kerning, ligatures, and spacing that rivals professional publishing

### 🎯 **NextResume's Unique Advantages**
- **ATS Compatibility**: Designed specifically for modern recruitment workflows  
- **Intelligent Spacing**: Lua algorithms automatically optimize layout and prevent overflow
- **Modern Icons**: SVG-based icons that scale perfectly at any size
- **Hyperlinked Elements**: Professional clickable contact information and references
- **Smart Content Management**: Advanced features like automatic date formatting and skill visualization



### 🛠️ **Built With Modern Technologies**

[![LaTeX][latex-shield]][latex-url]
[![LuaTeX][luatex-shield]][luatex-url]
[![LaTeX3][latex3-shield]][latex3-url]

**Core Technologies:**
- **LaTeX3** - Advanced programming layer for robust document processing
- **LuaLaTeX** - Modern engine with Lua scripting integration
- **TikZ/PGF** - Professional graphics and visual elements
- **FontSpec** - Advanced typography and font management  
- **Hyperref** - Smart PDF features and accessibility



## Getting Started

### 📋 **Prerequisites**

**Required:**
- **LaTeX Distribution**: [MiKTeX](https://miktex.org/download) (Windows) or [TeX Live](https://www.tug.org/texlive/) (Cross-platform)
- **LuaLaTeX**: Included with modern LaTeX distributions

**Recommended Development Environment:**
- **[Visual Studio Code](https://code.visualstudio.com/)**
- **[LuaTeX Extension](https://marketplace.visualstudio.com/items?itemName=JosefFriedrich.luatex)** - *One-click install that includes:*
  - LaTeX Workshop
  - Lua Language Server  
  - Complete LaTeX development environment

**Optional (for SVG compilation):**
- **[Inkscape](https://inkscape.org/)** - Required only if you want to modify the included SVG icons

### 🚀 **Installation**

**Option 1: Clone the Repository**
```bash
git clone https://github.com/D-Naveenz/NextResume.git
cd NextResume
```

**Option 2: Download Essential Files**
Copy these files to your project directory:
- `nextresume.cls` - The main document class
- `template.tex` - Complete showcase template
- `next_tokengrid.lua` - Lua token processing module  
- `next_utils.lua` - Lua utility functions
- SVG icons and fonts folders

### ⚡ **Quick Start**
1. Open `template.tex` in VS Code
2. Install the LuaTeX extension when prompted
3. Press `Ctrl+Alt+B` to build with LuaLaTeX  
4. Your professional resume PDF is ready!

<p align="right">(<a href="#readme-top">back to top</a>)</p>



---

## 🔧 Usage & Features

### 📋 **Compilation Requirements**

**NextResume v2.0.0** requires **LuaLaTeX** for optimal performance:

```bash
lualatex template.tex
```

**Why LuaLaTeX?**
- Modern UTF-8 support and font handling
- Lua scripting integration for dynamic content
- Better performance with complex layouts
- Native SVG support through modern packages

### 🎨 **Document Class Options**

```latex
\documentclass[10pt,a4paper,withhyper,fieldnames]{nextresume}
```

**Available Options:**
- `withhyper` - Enables clickable hyperlinks in contact information
- `fieldnames` - Shows field labels (Email, Phone, etc.) for better ATS parsing
- `normalphoto` - Use rectangular photos instead of circular (coming in v2.1)

### 🖼️ **Professional Photo Integration**

```latex
\begin{resumeheader}[3]
    \profilephoto{Globe_High}{2.8cm}
    \name{Your Name}
    \jobtitle{Your Title}
\end{resumeheader}
```

### 📱 **Modern Contact Information**

NextResume includes built-in support for modern platforms with beautiful SVG icons:

```latex
\email{your@email.com}
\phone{+1-555-123-4567}  
\homepage{www.yoursite.com}
\linkedin{your-linkedin}
\github{your-github}
\medium{@your-medium}
\twitter{your-twitter}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



## ✨ Core Features

### 🎯 **Single-Column ATS-Optimized Layout**
Unlike complex multi-column templates, NextResume uses a clean single-column design that:
- **Passes ATS systems** with perfect content parsing
- **Maintains readability** across all devices and screen readers  
- **Flows naturally** without complex column breaks or alignment issues

### 📊 **Advanced Skills Visualization**

**Weighted Skills with Visual Ratings:**
```latex
\begin{skillsection}{Cloud Technologies}
    \weightedskill{Azure}{4.5}
    \weightedskill{AWS}{3.5}  
    \weightedskill{GCP}{4}
\end{skillsection}
```

**Technology Tags:**
```latex
\nextTechstack{React, Node.js, PostgreSQL, AWS, Docker}
```

### 📈 **Professional Timeline System**

**Experience Timeline:**
```latex
\begin{nexttimeline}
    \nexttimelineevent{\nextDateAndLocation[startdate=2021-03-01, location={San Francisco, CA}]}{
        \nextItemHeading{Senior Full-Stack Developer}
        \nextItemSubheading{CloudTech Solutions}
        \begin{itemize}
            \item Led team of 8 engineers in developing microservices platform
            \item Increased deployment frequency by 300%
        \end{itemize}
        \nextTechstack{React, Node.js, PostgreSQL, AWS}
    }
\end{nexttimeline}
```

### 🎨 **Intelligent Design Elements**

**Smart Tags with Automatic Wrapping:**
```latex
\nextTag{System Architecture}
\nextTag{Technical Leadership}  
\nextTag{Performance Optimization}
```

**Project Showcases with Links:**
```latex
\nextProjectRef{https://github.com/username/project}[GitHub Repository]
```

### 🔧 **Lua-Powered Intelligence**
- **Automatic spacing optimization** prevents text overflow
- **Dynamic content processing** for consistent formatting
- **Smart date handling** with flexible input formats
- **Token-based layout management** for perfect alignment

<p align="right">(<a href="#readme-top">back to top</a>)</p>



## 🎨 Customization & Theming

### 🌈 **Color Schemes**

NextResume offers complete color customization using intuitive color names:

```latex
\colorlet{name}{black}
\colorlet{tagline}{EvertonBlue}
\colorlet{heading}{AstrosNavy}  
\colorlet{headingrule}{UranianBlue}
\colorlet{subheading}{Cerulean}
\colorlet{accent}{EvertonBlue}
\colorlet{emphasis}{SlateGrey}
\colorlet{link}{DodgerBlue}
\colorlet{body}{LightGrey}
```

### 🔗 **Intelligent Hyperlinks**

The `withhyper` option creates smart, clickable contact information:
- **Automatic URL generation** for social platforms
- **Professional email links** with proper mailto: formatting  
- **Accessible design** with proper link colors and hover states
- **ATS-safe fallbacks** when hyperlinks aren't supported

### 🖼️ **Custom Information Fields**

Create your own contact fields with custom icons:

```latex
\NewInfoField{gitlab}{\faGitlab}[https://gitlab.com/]
\gitlab{your-username}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



## 🤖 ATS Compatibility

### ✅ **Designed for Modern Recruitment**

NextResume is built from the ground up for **Applicant Tracking System (ATS) compatibility**:

- **Single-column layout** ensures linear content parsing
- **Semantic structure** with proper headings and sections  
- **Plain text accessibility** using `accsupp` package for icon replacement
- **Clean PDF output** that copy-pastes correctly from any viewer
- **Proper metadata** integration for enhanced discoverability

**Test Your Resume:**
```bash
# Extract plain text to verify ATS readability
pdftotext -raw template.pdf output.txt
```

### 🧪 **Validation Tools**
- **PDF/A compliance** for long-term archival
- **Accessibility standards** with proper text alternatives
- **Cross-platform compatibility** tested on major ATS platforms

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---



## 🗺️ Roadmap & Future Development

### 📋 **Version 2.1 (Coming Soon)**
- **Multi-column layouts** for academic CVs and portfolios  
- **Enhanced photo options** (rectangular, custom shapes)
- **Advanced timeline features** (project duration indicators, skill progression)
- **More built-in themes** and color schemes

### 🔮 **Version 3.0 (Future Vision)**  
- **ConTeXt integration** for ultimate typographic control
- **Interactive PDF features** (expandable sections, embedded media)
- **Multi-language support** with automatic RTL text handling
- **AI-powered content suggestions** and optimization hints

### 🚀 **Experimental Features**
- **Real-time collaboration** tools for team-based resume creation  
- **Integration with job boards** for automatic formatting optimization
- **Accessibility enhancements** beyond current ATS requirements

---

## 🤝 Contributing

We're building the future of professional document creation! **Contributions are highly encouraged** and every improvement makes NextResume better for everyone.

### 🌟 **How to Contribute**

1. **🍴 Fork** the repository
2. **🌿 Create** your feature branch: `git checkout -b feature/AmazingFeature`  
3. **💝 Commit** your changes: `git commit -m 'Add some AmazingFeature'`
4. **🚀 Push** to the branch: `git push origin feature/AmazingFeature`
5. **📬 Open** a Pull Request

### 💡 **Areas We Need Help With**
- **LaTeX/Lua expertise** for advanced typesetting features
- **Design contributions** for new themes and layouts  
- **Testing and validation** across different ATS platforms
- **Documentation and tutorials** for new users
- **Accessibility improvements** for inclusive design

### 🏆 **Recognition**
Contributors are recognized in our Hall of Fame and receive priority support for their projects!

<p align="right">(<a href="#readme-top">back to top</a>)</p>



---

## 📄 License

Distributed under the **LaTeX Project Public License (LPPL) v1.3c**. See `LICENSE.md` for more information.

This license ensures that NextResume remains freely available while maintaining quality and compatibility standards.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 📞 Contact & Support

**Naveen Dharmathunga** - *Creator & Lead Developer*
- 🐦 Twitter: [@XerDuke](https://x.com/dharmathunga)  
- 📧 Email: dasheenaveen@outlook.com
- 💼 LinkedIn: [Naveen Dharmathunga](https://linkedin.com/in/naveen-dharmathunga)

**Project Links:**
- 🔗 Repository: [NextResume on GitHub](https://github.com/D-Naveenz/NextResume)
- 📋 Issues: [Report Bugs & Request Features](https://github.com/D-Naveenz/NextResume/issues)
- 📖 Documentation: [Wiki & Guides](https://github.com/D-Naveenz/NextResume/wiki)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 🙏 Acknowledgments & Credits

NextResume stands on the shoulders of giants in the LaTeX community:

- **[LaTeX Project Team](https://www.latex-project.org/about/team/)** - For creating the foundation of modern document preparation
- **[LuaTeX Development Team](http://www.luatex.org/)** - For revolutionizing LaTeX with Lua integration  
- **[Font Awesome](https://fontawesome.com)** - For the comprehensive icon library
- **[Shields.io](https://shields.io)** - For beautiful repository badges
- **Modern LaTeX Community** - For packages like `fontspec`, `xcolor`, `tikz`, and `hyperref`

**Special Recognition:**
- Original concepts inspired by resume design patterns in the LaTeX community
- Beta testers and early adopters who provided invaluable feedback  
- Contributors who helped refine and improve NextResume

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/D-Naveenz/NextCV.svg?style=for-the-badge
[contributors-url]: https://github.com/D-Naveenz/NextCV/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/D-Naveenz/NextCV.svg?style=for-the-badge
[forks-url]: https://github.com/D-Naveenz/NextCV/network/members
[stars-shield]: https://img.shields.io/github/stars/D-Naveenz/NextCV.svg?style=for-the-badge
[stars-url]: https://github.com/D-Naveenz/NextCV/stargazers
[issues-shield]: https://img.shields.io/github/issues/D-Naveenz/NextCV.svg?style=for-the-badge
[issues-url]: https://github.com/D-Naveenz/NextCV/issues
[license-shield]: https://img.shields.io/github/license/D-Naveenz/NextCV.svg?style=for-the-badge
[license-url]: https://github.com/D-Naveenz/NextCV/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/dasheewd/
[latex-shield]: https://img.shields.io/badge/latex-%23008080.svg?style=for-the-badge&logo=latex&logoColor=white
[Latex-url]: https://www.latex-project.org/
[luatex-shield]: https://img.shields.io/badge/LuaTeX-2.1.0-blue?style=for-the-badge&logo=lua
[luatex-url]: http://www.luatex.org/
[latex3-shield]: https://img.shields.io/badge/LaTeX3-L3%20Programming-green?style=for-the-badge&logo=latex  
[latex3-url]: https://www.latex-project.org/latex3/