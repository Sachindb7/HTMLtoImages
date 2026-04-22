$pages = @('html-to-png','html-to-jpg','html-to-webp','code-to-image','html-table-to-image','html-email-to-image','tailwind-to-image')
$basePath = 'c:\Users\hp\Downloads\htmltoimages (1)\STATIC'

foreach ($p in $pages) {
    $filePath = Join-Path $basePath "$p\index.html"
    $content = Get-Content $filePath -Raw
    
    # 1. Fix app-container CSS to remove fixed height that causes cutoff
    $content = $content -replace 'height: 80vh; min-height: 700px;', 'min-height: 700px; height: calc(100vh - 200px);'
    
    # Also add min-height for mobile to prevent collapsing
    $mobileCSS = @'
        @media (max-width: 900px) { 
            .app-container { grid-template-columns: 1fr; height: auto; } 
            .panel { min-height: 450px; }
            .steps { grid-template-columns: 1fr; }
'@
    $content = $content -replace '(?s)@media \(max-width: 900px\) \{[^{}]*\.app-container \{[^}]+\}[^{}]*\.steps \{[^}]+\}', $mobileCSS

    # 2. Extract and remove the erroneous CSS from inside <textarea>
    # Find what's inside <textarea id="codeEditor"...> ... </textarea>
    if ($content -match '(?s)<textarea id="codeEditor"[^>]*>(.*?)</textarea>') {
        $textareaContent = $matches[1]
        
        $hasBadCss = $false
        
        # Check if cookie banner CSS is in textarea
        if ($textareaContent -match '(?s)\.cookie-banner \{.*?\}') {
            $textareaContent = $textareaContent -replace '(?s)\s*\.cookie-banner \{.*?\}', ''
            $textareaContent = $textareaContent -replace '(?s)\s*\.cookie-banner a \{.*?\}', ''
            $textareaContent = $textareaContent -replace '(?s)\s*\.cookie-banner button \{.*?\}', ''
            $textareaContent = $textareaContent -replace '(?s)\s*\.cookie-banner button:hover \{.*?\}', ''
            $textareaContent = $textareaContent -replace '(?s)\s*@media \(max-width: 600px\) \{ \.cookie-banner \{.*?\} \}', ''
            $hasBadCss = $true
        }
        
        # Check if the global @media (max-width: 600px) fix is in textarea
        if ($textareaContent -match '(?s)@media \(max-width: 600px\) \{\s*\.navbar \{') {
            $textareaContent = $textareaContent -replace '(?s)\s*@media \(max-width: 600px\) \{\s*\.navbar \{.*?\/\* Adjust hero padding since navbar is taller \*\/\s*\.hero \{\s*padding-top: 140px !important;\s*\}\s*\}', ''
            $hasBadCss = $true
        }
        
        if ($hasBadCss) {
            # Update the file content with the cleaned textarea
            $content = $content -replace '(?s)(<textarea id="codeEditor"[^>]*>).*?(</textarea>)', "`$1$textareaContent`$2"
            Write-Output "Cleaned bad CSS from textarea in $p"
        }
    }
    
    # 3. Add the layout fix to the <head> if it's not already there
    $layoutFix = @'
        @media (max-width: 600px) {
            .navbar {
                padding: 12px 15px !important;
                width: 95% !important;
                flex-direction: column !important;
                border-radius: 16px !important;
                gap: 10px !important;
            }
            .nav-links {
                gap: 20px !important;
                width: 100% !important;
                justify-content: center !important;
            }
            .logo {
                font-size: 1.2rem !important;
                gap: 8px !important;
            }
            .nav-links a {
                font-size: 0.95rem !important;
            }
            .preview-wrapper {
                padding: 15px !important;
            }
            textarea#codeEditor {
                min-width: 100% !important;
            }
            .hero {
                padding-top: 140px !important;
            }
        }
'@
    # Only add if it's not present in the head (meaning not between <head> and </head>)
    $headContent = [regex]::match($content, '(?s)<head>.*?</head>').Value
    if ($headContent -notmatch '\/\* Adjust hero padding since navbar is taller \*\/') {
        # Check if it was added using a different format
        if ($headContent -notmatch '\.preview-wrapper \{\s*padding: 15px !important;') {
            $content = $content -replace '(?s)(\.cookie-banner \{.*?\} \})', "`$1`n$layoutFix"
            Write-Output "Added global mobile CSS to $p"
        }
    }
    
    Set-Content $filePath -Value $content -NoNewline
}
Write-Output "Done"
