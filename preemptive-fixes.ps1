$basePath = 'c:\Users\hp\Downloads\htmltoimages (1)\STATIC'

# 1. Fix allowTaint bug in all index.html files (except root and blog)
$toolDirs = @('html-to-jpg', 'html-to-png', 'html-to-webp', 'code-to-image', 'html-table-to-image', 'html-email-to-image', 'tailwind-to-image')

foreach ($dir in $toolDirs) {
    $filePath = Join-Path $basePath "$dir\index.html"
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw
        $content = $content -replace 'logging: false, useCORS: true, allowTaint: true', 'logging: false, useCORS: true'
        Set-Content $filePath -Value $content -NoNewline
        Write-Output "Fixed allowTaint in $dir"
    }
}

# 2. Update blog bylines to Sachin Bhanushali instead of HTMLtoImages Team
$blogIndex = Join-Path $basePath 'blog\index.html'
if (Test-Path $blogIndex) {
    $content = Get-Content $blogIndex -Raw
    # There are no bylines on the blog cards in the listing page, but let's check.
}

$blogPages = Get-ChildItem -Path (Join-Path $basePath 'blog') -Filter '*.html' -Recurse
foreach ($f in $blogPages) {
    $content = Get-Content $f.FullName -Raw
    $content = $content -replace '<span><i class="fas fa-user"></i> HTMLtoImages Team</span>', '<span><i class="fas fa-user"></i> Sachin Bhanushali</span>'
    Set-Content $f.FullName -Value $content -NoNewline
    Write-Output "Updated author byline in $($f.Name)"
}

Write-Output "Done."
