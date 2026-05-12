$src = 'C:\Users\hp\.gemini\antigravity\brain\6c5a5c80-4e70-413c-9188-bb5686650327'
$dst = 'c:\Users\hp\Downloads\htmltoimages (1)\STATIC\blog\images'

Copy-Item "$src\blog_html_to_image_1778599133922.png" "$dst\html-to-image-guide.png"
Copy-Item "$src\blog_png_vs_jpg_1778599153793.png" "$dst\png-vs-jpg-vs-webp.png"
Copy-Item "$src\blog_code_screenshot_1778599181929.png" "$dst\code-screenshot-tools.png"
Copy-Item "$src\blog_tailwind_tips_1778599198248.png" "$dst\tailwind-css-tips.png"
Copy-Item "$src\blog_email_design_1778599222326.png" "$dst\html-email-design-guide.png"
Copy-Item "$src\blog_grid_flexbox_1778599241231.png" "$dst\css-grid-flexbox-guide.png"
Copy-Item "$src\blog_web_performance_1778599257987.png" "$dst\web-performance-optimization.png"
Copy-Item "$src\blog_responsive_design_1778599276669.png" "$dst\responsive-design-best-practices.png"
Copy-Item "$src\blog_table_styling_1778599295217.png" "$dst\html-table-styling.png"
Copy-Item "$src\blog_csr_vs_ssr_1778599311416.png" "$dst\client-side-vs-server-side.png"
Copy-Item "$src\favicon_htmltoimages_1778599118088.png" 'c:\Users\hp\Downloads\htmltoimages (1)\STATIC\favicon.png' -Force

Write-Output "All images copied!"
Get-ChildItem "$dst" | Select-Object Name, Length
