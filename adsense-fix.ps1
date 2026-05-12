$basePath = 'c:\Users\hp\Downloads\htmltoimages (1)\STATIC'

# ============================================
# STEP 1: Add favicon <link> to ALL HTML pages
# ============================================
Write-Output "=== STEP 1: Adding favicon to all pages ==="

$faviconLink = '    <link rel="icon" type="image/png" href="/favicon.png">'

# Get all HTML files recursively
$htmlFiles = Get-ChildItem -Path $basePath -Filter '*.html' -Recurse

foreach ($f in $htmlFiles) {
    $content = Get-Content $f.FullName -Raw
    
    # Skip if already has favicon
    if ($content -match 'rel="icon"') {
        Write-Output "  SKIP (already has favicon): $($f.FullName)"
        continue
    }
    
    # Add after <meta name="viewport"...> line
    if ($content -match '(<meta name="viewport"[^>]*>)') {
        $content = $content -replace '(<meta name="viewport"[^>]*>)', "`$1`n$faviconLink"
        Set-Content $f.FullName -Value $content -NoNewline
        Write-Output "  ADDED favicon: $($f.Name)"
    } else {
        Write-Output "  WARN no viewport meta found: $($f.Name)"
    }
}

# ============================================
# STEP 2: Replace blog card placeholder icons with real images
# ============================================
Write-Output ""
Write-Output "=== STEP 2: Updating blog listing page with real images ==="

$blogIndex = Join-Path $basePath 'blog\index.html'
$blogContent = Get-Content $blogIndex -Raw

# Map: blog slug -> image filename (these all go in /blog/images/)
$blogImages = @{
    'html-to-image-guide' = 'html-to-image-guide.png'
    'png-vs-jpg-vs-webp' = 'png-vs-jpg-vs-webp.png'
    'code-screenshot-tools' = 'code-screenshot-tools.png'
    'tailwind-css-tips' = 'tailwind-css-tips.png'
    'html-email-design-guide' = 'html-email-design-guide.png'
    'css-grid-flexbox-guide' = 'css-grid-flexbox-guide.png'
    'web-performance-optimization' = 'web-performance-optimization.png'
    'responsive-design-best-practices' = 'responsive-design-best-practices.png'
    'html-table-styling' = 'html-table-styling.png'
    'client-side-vs-server-side' = 'client-side-vs-server-side.png'
}

foreach ($slug in $blogImages.Keys) {
    $imgFile = $blogImages[$slug]
    # Replace the icon-based div with an img-based div
    # Pattern: <div class="blog-card-img" style="background:linear-gradient(...);">...</div>
    # We want to keep it as the card for /blog/$slug/
    $oldPattern = "(?s)(href=""/blog/$slug/"" class=""blog-card"">)\s*<div class=""blog-card-img"" style=""[^""]*"">\s*<i[^>]*></i>\s*</div>"
    $newReplacement = "`$1`n            <div class=""blog-card-img"" style=""background:#f1f5f9;padding:0;overflow:hidden;""><img src=""/blog/images/$imgFile"" alt=""$slug"" style=""width:100%;height:100%;object-fit:cover;""></div>"
    
    $blogContent = [regex]::Replace($blogContent, $oldPattern, $newReplacement)
}

Set-Content $blogIndex -Value $blogContent -NoNewline
Write-Output "  Updated blog/index.html with real images"

# ============================================
# STEP 3: Update homepage blog section with real images too
# ============================================
Write-Output ""
Write-Output "=== STEP 3: Updating homepage blog section ==="

$homePage = Join-Path $basePath 'index.html'
$homeContent = Get-Content $homePage -Raw

foreach ($slug in $blogImages.Keys) {
    $imgFile = $blogImages[$slug]
    $oldPattern = "(?s)(href=""/blog/$slug/"" class=""blog-card"">)\s*<div class=""blog-card-img"" style=""[^""]*"">\s*<i[^>]*></i>\s*</div>"
    $newReplacement = "`$1`n            <div class=""blog-card-img"" style=""background:#f1f5f9;padding:0;overflow:hidden;""><img src=""/blog/images/$imgFile"" alt=""$slug"" style=""width:100%;height:100%;object-fit:cover;""></div>"
    
    $homeContent = [regex]::Replace($homeContent, $oldPattern, $newReplacement)
}

Set-Content $homePage -Value $homeContent -NoNewline
Write-Output "  Updated index.html homepage blog cards"

# ============================================
# STEP 4: Standardize navbars on about.html, contact.html, privacy.html, terms.html
# ============================================
Write-Output ""
Write-Output "=== STEP 4: Standardizing navbars on info pages ==="

$standardNav = @'
        <div class="nav-links">
            <a href="/">Home</a>
            <a href="/#tools">Tools</a>
            <a href="/blog/">Blog</a>
            <a href="/contact">Contact</a>
        </div>
'@

$infoPages = @('about.html', 'contact.html', 'privacy.html', 'terms.html')
foreach ($page in $infoPages) {
    $filePath = Join-Path $basePath $page
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw
        $content = $content -replace '(?s)<div class="nav-links">.*?</div>', $standardNav
        Set-Content $filePath -Value $content -NoNewline
        Write-Output "  Standardized navbar: $page"
    }
}

# Also fix blog listing page and all blog post pages
$blogPages = Get-ChildItem -Path (Join-Path $basePath 'blog') -Filter '*.html' -Recurse
foreach ($f in $blogPages) {
    $content = Get-Content $f.FullName -Raw
    $content = $content -replace '(?s)<div class="nav-links">.*?</div>', $standardNav
    Set-Content $f.FullName -Value $content -NoNewline
    Write-Output "  Standardized navbar: blog/$($f.Name)"
}

# ============================================
# STEP 5: Update sitemap dates
# ============================================
Write-Output ""
Write-Output "=== STEP 5: Updating sitemap dates ==="

$sitemapPath = Join-Path $basePath 'sitemap.xml'
$today = Get-Date -Format 'yyyy-MM-dd'
$sitemapContent = Get-Content $sitemapPath -Raw
$sitemapContent = $sitemapContent -replace '<lastmod>2026-04-\d{2}</lastmod>', "<lastmod>$today</lastmod>"
Set-Content $sitemapPath -Value $sitemapContent -NoNewline
Write-Output "  Updated all sitemap dates to $today"

# ============================================
# STEP 6: Add sitemap entry for 404 page
# ============================================

Write-Output ""
Write-Output "=== ALL DONE ==="
