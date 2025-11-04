# PowerShell script to clean LaTeX auxiliary files
# Usage: .\clean-latex.ps1

Write-Host "Cleaning LaTeX auxiliary files..." -ForegroundColor Yellow

$extensions = @(
    "*.aux", "*.log", "*.out", "*.fdb_latexmk", "*.fls", 
    "*.synctex.gz", "*.toc", "*.lof", "*.lot", "*.bbl", 
    "*.blg", "*.idx", "*.ind", "*.ilg", "*.nav", "*.snm", 
    "*.vrb", "*.figlist", "*.makefile", "*.fignums",
    "*.bcf", "*.run.xml", "*.xdv"
)

$filesRemoved = 0
foreach ($ext in $extensions) {
    $files = Get-ChildItem -Path . -Filter $ext -Recurse -ErrorAction SilentlyContinue
    if ($files) {
        $files | Remove-Item -Force
        $filesRemoved += $files.Count
        Write-Host "Removed $($files.Count) $ext files" -ForegroundColor Green
    }
}

if ($filesRemoved -eq 0) {
    Write-Host "No auxiliary files found to clean." -ForegroundColor Cyan
} else {
    Write-Host "Total files removed: $filesRemoved" -ForegroundColor Green
}

Write-Host "LaTeX cache cleanup complete!" -ForegroundColor Green