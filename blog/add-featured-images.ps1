$basePath = 'c:\Users\hp\Downloads\htmltoimages (1)\STATIC\blog'
$blogDirs = Get-ChildItem -Path $basePath -Directory

foreach ($dir in $blogDirs) {
    if ($dir.Name -eq 'images') { continue }
    
    $indexPath = Join-Path $dir.FullName 'index.html'
    if (Test-Path $indexPath) {
        $slug = $dir.Name
        $content = Get-Content $indexPath -Raw
        
        # Check if we already injected the image to avoid duplicates
        if ($content -match '<div class="article-featured-image"') {
            Write-Output "Image already added to $slug"
            continue
        }
        
        $imgDiv = "`n    <div class=""article-featured-image"" style=""max-width: 800px; margin: 0 auto 40px; padding: 0 20px;"">`n        <img src=""/blog/images/$slug.png"" alt=""$slug"" style=""width: 100%; height: auto; display: block; border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.08);"">`n    </div>`n"
        
        # Replace `</header>` with `</header>` + the image div
        if ($content -match '</header>') {
            $content = $content -replace '</header>', "</header>$imgDiv"
            Set-Content $indexPath -Value $content -NoNewline
            Write-Output "Added featured image to $slug"
        } else {
            Write-Output "Could not find </header> in $slug"
        }
    }
}
Write-Output "Done adding featured images to blog posts."
