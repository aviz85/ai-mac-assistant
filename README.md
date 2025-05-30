# AI Mac Assistant

כלי macOS שמוסיף אופציה בתפריט הקליק הימני של Finder להרצת פקודות terminal באמצעות Claude AI.

## ✨ תכונות

- 🔍 **אינטגרציה עם Finder** - קליק ימני על כל קובץ
- 🤖 **AI מתקדם** - מבוסס על Claude של Anthropic
- 🛡️ **בטיחות מקסימלית** - אישור משתמש לכל פקודה
- 🌍 **תמיכה בעברית ואנגלית** - ממשק דו-לשוני
- ⚡ **מהיר ויעיל** - תגובה מיידית

## 🚀 התחלה מהירה

### 1. דרישות מערכת
- macOS 12.0+
- **Xcode 14.0+** (חובה - לא רק Command Line Tools!)
- Claude API Key

### 2. התקנה
```bash
# שכפל את הפרויקט
git clone <repository-url>
cd ai-mac-assistant

# הרץ סקריפט בנייה
./build.sh

# פתח ב-Xcode
open AIAssistant.xcodeproj
```

### 3. הגדרה
1. הגדר Development Team ב-Xcode
2. בנה והתקן את האפליקציה
3. אפשר את ההרחבה בהעדפות המערכת
4. הגדר Claude API Key

## 📖 איך זה עובד

1. **קליק ימני** על קובץ ב-Finder
2. **בחר "AI Assistant"** מהתפריט
3. **הזן בקשה** בשפה טבעית
4. **אשר את הפקודה** שנוצרה
5. **הפקודה מתבצעת** אוטומטית

## 💡 דוגמאות שימוש

```
"פתח את הקובץ"              → open "filename.txt"
"העתק לשולחן העבודה"         → cp "file.jpg" ~/Desktop/
"דחס את הקובץ"              → zip "file.zip" "file.txt"
"הצג מידע על הקובץ"          → ls -la "file.pdf"
"המר ל-PNG"                 → sips -s format png "image.jpg" --out "image.png"
```

## 🛡️ אבטחה

- ✅ **אישור משתמש** לכל פקודה
- ✅ **זיהוי פקודות מסוכנות** אוטומטי
- ✅ **Sandbox מלא** לאפליקציה
- ✅ **API Key מקומי** - לא נשלח לשרתים חיצוניים

## 🔧 פתרון בעיות נפוצות

### ❌ "xcode-select: error: tool 'xcodebuild' requires Xcode"
```bash
# התקן Xcode מ-App Store, לאחר מכן:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### ❌ ההרחבה לא מופיעה בתפריט
1. ודא שההרחבה מופעלת בהעדפות המערכת
2. אתחל את Finder: `killall Finder`
3. ודא שהאפליקציה רצה לפחות פעם אחת

### ❌ שגיאות בנייה ב-Xcode
1. הגדר Development Team בהגדרות הפרויקט
2. שנה Bundle Identifier לייחודי
3. נקה את הפרויקט: Product > Clean Build Folder

## 📁 מבנה הפרויקט

```
ai-mac-assistant/
├── AIAssistant/              # אפליקציה ראשית
│   ├── AppDelegate.swift     # נקודת כניסה
│   ├── ViewController.swift  # ממשק הגדרות
│   └── ...
├── FinderExtension/          # הרחבת Finder
│   ├── FinderSync.swift      # לוגיקה ראשית
│   └── ...
├── Shared/                   # קוד משותף
│   ├── AIService.swift       # שירות Claude
│   └── TerminalExecutor.swift # הרצת פקודות
└── Documentation/            # תיעוד
```

## 🔗 קישורים שימושיים

- [מדריך התקנה מפורט](INSTALLATION.md)
- [דוגמאות שימוש](EXAMPLES.md)
- [Claude API Documentation](https://docs.anthropic.com/claude/reference/getting-started-with-the-api)

## 🤝 תרומה לפרויקט

1. Fork את הפרויקט
2. צור branch חדש (`git checkout -b feature/amazing-feature`)
3. Commit את השינויים (`git commit -m 'Add amazing feature'`)
4. Push ל-branch (`git push origin feature/amazing-feature`)
5. פתח Pull Request

## 📄 רישיון

פרויקט זה מופץ תחת רישיון MIT. ראה `LICENSE` לפרטים נוספים.

## ⚠️ הגבלת אחריות

כלי זה מריץ פקודות terminal על המחשב שלך. למרות מנגנוני הבטיחות, השתמש בו באחריותך בלבד.

---

**נוצר עם ❤️ עבור קהילת macOS** 