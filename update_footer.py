import os, glob, re

footer_replacement = '''        <div class="copyright">
            &copy; 2026 htmltoimages.com. All rights reserved.<br>
            <span style="font-size: 0.9rem; margin-top: 10px; display: inline-block; color: var(--text-muted);">Built with ❤️ &amp; ☕ by Sachin Bhanushali</span>
        </div>'''

policy_replacement = '''    <div style="text-align: center; margin-top: 50px; font-size: 0.9rem; color: var(--text-muted); border-top: 1px solid var(--border-color); padding-top: 20px; margin-bottom: 20px;">
        Built with ❤️ &amp; ☕ by Sachin Bhanushali
    </div>
</body>'''

html_files = glob.glob('**/*.html', recursive=True)
count = 0

for file in html_files:
    file = file.replace('\\\\', '/')
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    changed = False
    
    if os.path.basename(file) in ['about.html', 'contact.html', 'privacy.html', 'terms.html']:
        if 'Built with' not in content and '</body>' in content:
            content = content.replace('</body>', policy_replacement)
            changed = True
    else:
        if '<div class="copyright">' in content and 'Built with' not in content:
            content = re.sub(r'<div class="copyright">.*?</div>', footer_replacement, content, flags=re.DOTALL)
            changed = True
            
    if changed:
        with open(file, 'w', encoding='utf-8') as f:
            f.write(content)
        count += 1
        
print(f'Updated {count} files')
