import sys
try:
    from PIL import Image
    img = Image.open(r'C:\Users\hp\.gemini\antigravity\brain\6c5a5c80-4e70-413c-9188-bb5686650327\ai_scams_2026_1782050443520.png')
    img.save(r'c:\Users\hp\Downloads\htmltoimages (1)\STATIC\blog\5-dangerous-ai-scams-2026\ai-scams.webp', 'webp', quality=85)
    print("Converted successfully to webp using PIL")
except Exception as e:
    print(f"PIL error: {e}")
    sys.exit(1)
