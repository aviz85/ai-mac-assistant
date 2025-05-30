# מדריך התקנה - AI Mac Assistant

## דרישות מערכת
- macOS 12.0 ומעלה
- **Xcode 14.0 ומעלה (חובה!)** - לא רק Command Line Tools
- Claude API Key (מ-Anthropic)

## שלב 0: התקנת Xcode (אם לא מותקן)

### אם אין לך Xcode מותקן:
1. פתח App Store
2. חפש "Xcode"
3. התקן את Xcode (זה יכול לקחת זמן - הקובץ גדול)
4. פתח את Xcode פעם אחת כדי לאשר את הרישיונות

### אם יש לך רק Command Line Tools:
```bash
# בדוק מה מותקן כרגע
xcode-select --print-path

# אם התוצאה היא /Library/Developer/CommandLineTools
# אתה צריך להתקין Xcode המלא מ-App Store
```

### לאחר התקנת Xcode:
```bash
# הגדר את Xcode כ-developer tools ברירת המחדל
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# בדוק שהשינוי עבד
xcode-select --print-path
# אמור להציג: /Applications/Xcode.app/Contents/Developer
```

## שלב 1: הכנת הפרויקט

1. פתח Terminal ונווט לתיקיית הפרויקט:
```bash
cd /path/to/ai-mac-assistant
```

2. הרץ את סקריפט הבנייה:
```bash
./build.sh
```

**אם אתה מקבל שגיאה "xcode-select: error":**
- ודא שXcode מותקן (לא רק Command Line Tools)
- הרץ: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`

## שלב 2: פתיחה ב-Xcode

1. פתח את הקובץ `AIAssistant.xcodeproj` ב-Xcode:
```bash
open AIAssistant.xcodeproj
```

2. בחר את הפרויקט בסרגל הצד השמאלי
3. בחר את ה-target "AIAssistant"
4. בלשונית "Signing & Capabilities":
   - הגדר את ה-Development Team שלך
   - ודא שה-Bundle Identifier ייחודי (למשל: `com.yourname.AIAssistant`)

5. חזור על השלב עבור ה-target "FinderExtension"

## שלב 3: בנייה והתקנה

1. בחר את ה-scheme "AIAssistant" מהתפריט העליון
2. לחץ על Product > Build (או Cmd+B)
3. אם הבנייה הצליחה, לחץ על Product > Run (או Cmd+R)

## שלב 4: הפעלת ההרחבה

1. פתח System Preferences (העדפות מערכת)
2. עבור אל Extensions
3. בחר "Finder Extensions" מהרשימה השמאלית
4. אפשר את "AI Assistant Finder Extension"

## שלב 5: הגדרת Claude API

### קבלת API Key:
1. עבור אל [console.anthropic.com](https://console.anthropic.com)
2. צור חשבון או התחבר
3. עבור אל API Keys
4. צור API Key חדש

### הגדרה באפליקציה:
1. פתח את אפליקציית AI Assistant
2. הזן את ה-API Key של Claude בשדה המתאים
3. לחץ על "שמור"
4. לחץ על "בדוק חיבור" כדי לוודא שהכל עובד

## שלב 6: שימוש

1. פתח Finder
2. לחץ קליק ימני על קובץ כלשהו
3. בחר "AI Assistant" מהתפריט
4. הזן את הבקשה שלך (למשל: "פתח את הקובץ", "העתק לשולחן העבודה")
5. אשר את הפקודה שנוצרה
6. הפקודה תתבצע אוטומטית!

## פתרון בעיות

### ❌ שגיאה: "xcode-select: error: tool 'xcodebuild' requires Xcode"
**פתרון:**
```bash
# התקן Xcode מ-App Store (לא רק Command Line Tools)
# לאחר מכן הרץ:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### ❌ ההרחבה לא מופיעה בתפריט
- ודא שההרחבה מופעלת בהעדפות המערכת
- נסה לאתחל את Finder: `killall Finder`
- בדוק שה-API Key מוגדר נכון
- ודא שהאפליקציה רצה לפחות פעם אחת

### ❌ שגיאות בנייה
- ודא שה-Development Team מוגדר
- בדוק שה-Bundle Identifier ייחודי
- נסה לנקות את הפרויקט: Product > Clean Build Folder
- ודא שיש לך גרסת Xcode עדכנית

### ❌ בעיות חיבור ל-Claude
- בדוק את ה-API Key (אמור להתחיל ב-`sk-ant-`)
- ודא שיש חיבור לאינטרנט
- בדוק את הגדרות הפיירוול
- ודא שיש לך קרדיט ב-Anthropic

### ❌ "Development Team" לא זמין
- פתח Xcode > Preferences > Accounts
- הוסף את Apple ID שלך
- אם אין לך חשבון מפתח, אתה יכול להשתמש בחשבון אישי (בחינם)

## אבטחה

- כל פקודה מוצגת למשתמש לאישור לפני ההרצה
- פקודות מסוכנות נחסמות אוטומטית
- ה-API Key נשמר באופן מקומי ב-UserDefaults
- האפליקציה פועלת ב-Sandbox מלא

## תמיכה

אם נתקלת בבעיות:
1. בדוק את הקונסול של macOS לשגיאות
2. ודא שכל הדרישות מתקיימות
3. נסה לבנות מחדש את הפרויקט
4. פתח issue בפרויקט עם פרטי השגיאה 