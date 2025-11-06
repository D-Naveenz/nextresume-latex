# Build script for NextCV LaTeX template
# Usage: .\build.ps1 [filename]
# If no filename is provided, defaults to template.tex

param(
    [string]$InputFile = "resume.tex"
)

Write-Host "Building LaTeX document: $InputFile" -ForegroundColor Green

# Ensure MiKTeX is in PATH
$env:PATH = "C:\Users\dashe\AppData\Local\Programs\MiKTeX\miktex\bin\x64;" + $env:PATH

# Check if input file exists
if (-not (Test-Path $InputFile)) {
    Write-Error "File '$InputFile' not found!"
    exit 1
}

# Clean previous build files (optional)
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
$cleanFiles = @("$baseName.aux", "$baseName.fdb_latexmk", "$baseName.fls", "$baseName.log", "$baseName.out", "$baseName.synctex.gz")
foreach ($file in $cleanFiles) {
    if (Test-Path $file) {
        Remove-Item $file -Force
        Write-Host "Cleaned: $file" -ForegroundColor Yellow
    }
}

# Compile with LuaLaTeX
Write-Host "Compiling with LuaLaTeX..." -ForegroundColor Cyan
& lualatex -interaction=nonstopmode $InputFile

if ($LASTEXITCODE -eq 0) {
    Write-Host "Compilation successful! PDF generated: $baseName.pdf" -ForegroundColor Green
    
    # Optional: Open the PDF
    if (Test-Path "$baseName.pdf") {
        $response = Read-Host "Open PDF? (y/N)"
        if ($response -eq 'y' -or $response -eq 'Y') {
            Start-Process "$baseName.pdf"
        }
    }
} else {
    Write-Host "Compilation failed. Check the log file for details." -ForegroundColor Red
    if (Test-Path "$baseName.log") {
        Write-Host "Log file: $baseName.log" -ForegroundColor Yellow
    }
    exit $LASTEXITCODE
}