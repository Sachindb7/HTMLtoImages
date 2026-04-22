$pages = @('html-to-png','html-to-jpg','html-to-webp','code-to-image','html-table-to-image','html-email-to-image','tailwind-to-image')
$basePath = 'c:\Users\hp\Downloads\htmltoimages (1)\STATIC'

$newNavLinks = @'
        <div class="nav-links">
            <a href="/">Home</a>
            <a href="#more-tools">Tools</a>
            <a href="/blog/">Blog</a>
            <a href="/contact">Contact</a>
            <a href="#faq">FAQ</a>
        </div>
'@

foreach ($p in $pages) {
    $filePath = Join-Path $basePath "$p\index.html"
    $content = Get-Content $filePath -Raw
    
    # Replace the existing nav-links div
    # Note: different tools might have slightly different existing nav-links blocks
    $content = $content -replace '(?s)<div class="nav-links">.*?</div>', $newNavLinks
    
    Set-Content $filePath -Value $content -NoNewline
    Write-Output "Updated navbar in $p"
}
Write-Output "Done!"
