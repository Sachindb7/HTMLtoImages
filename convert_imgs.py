import sys
from PIL import Image

def convert_to_webp(src, dest):
    try:
        img = Image.open(src)
        img.save(dest, 'webp', quality=85)
        print(f"Converted {src} -> {dest}")
    except Exception as e:
        print(f"Error converting {src}: {e}")

convert_to_webp(r'c:\Users\hp\Downloads\img1.png', r'c:\Users\hp\Downloads\htmltoimages (1)\STATIC\blog\5-dangerous-ai-scams-2026\img1.webp')
convert_to_webp(r'c:\Users\hp\Downloads\img2.png', r'c:\Users\hp\Downloads\htmltoimages (1)\STATIC\blog\5-dangerous-ai-scams-2026\img2.webp')
convert_to_webp(r'c:\Users\hp\Downloads\img3.png', r'c:\Users\hp\Downloads\htmltoimages (1)\STATIC\blog\5-dangerous-ai-scams-2026\img3.webp')
