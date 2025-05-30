#!/bin/bash

# AI Mac Assistant Build Script

echo "🚀 בונה AI Mac Assistant..."

# בדיקה אם Xcode מותקן
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ xcodebuild לא נמצא."
    echo "💡 אנא התקן Xcode מ-App Store (לא רק Command Line Tools)"
    exit 1
fi

# בדיקה אם Xcode מוגדר נכון
XCODE_PATH=$(xcode-select --print-path)
if [[ "$XCODE_PATH" == "/Library/Developer/CommandLineTools" ]]; then
    echo "⚠️  זוהה Command Line Tools במקום Xcode המלא"
    echo "💡 פתרון:"
    echo "   1. התקן Xcode מ-App Store"
    echo "   2. הרץ: sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
    echo ""
    
    # בדיקה אם Xcode קיים
    if [ -d "/Applications/Xcode.app" ]; then
        echo "🔧 Xcode נמצא! מנסה להגדיר אוטומטית..."
        sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
        if [ $? -eq 0 ]; then
            echo "✅ Xcode הוגדר בהצלחה!"
        else
            echo "❌ נכשל בהגדרת Xcode. הרץ ידנית:"
            echo "   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
            exit 1
        fi
    else
        echo "❌ Xcode לא נמצא ב-/Applications/Xcode.app"
        echo "   אנא התקן Xcode מ-App Store תחילה"
        exit 1
    fi
fi

echo "✅ Xcode מוגדר נכון: $XCODE_PATH"

# בדיקה שהפרויקט קיים
if [ ! -f "AIAssistant.xcodeproj/project.pbxproj" ]; then
    echo "❌ קובץ הפרויקט לא נמצא"
    echo "   ודא שאתה בתיקיית הפרויקט הנכונה"
    exit 1
fi

# ניקוי build קודם
echo "🧹 מנקה build קודם..."
xcodebuild clean -project AIAssistant.xcodeproj -scheme AIAssistant -quiet

# בנייה של הפרויקט
echo "🔨 בונה את הפרויקט..."
xcodebuild build -project AIAssistant.xcodeproj -scheme AIAssistant -configuration Release -quiet

if [ $? -eq 0 ]; then
    echo "✅ הבנייה הושלמה בהצלחה!"
    echo ""
    echo "📋 שלבים נוספים:"
    echo "1. פתח את הפרויקט: open AIAssistant.xcodeproj"
    echo "2. הגדר Development Team בהגדרות הפרויקט"
    echo "3. בנה והתקן את האפליקציה (Cmd+R)"
    echo "4. אפשר את ההרחבה בהעדפות המערכת > Extensions > Finder Extensions"
    echo "5. הגדר Claude API Key באפליקציה"
    echo ""
    echo "🎉 AI Assistant מוכן לשימוש!"
    echo ""
    echo "💡 טיפ: אם זו הפעם הראשונה, הרץ:"
    echo "   open AIAssistant.xcodeproj"
else
    echo "❌ הבנייה נכשלה."
    echo ""
    echo "🔍 בעיות נפוצות ופתרונות:"
    echo "1. Development Team לא מוגדר:"
    echo "   - פתח הפרויקט ב-Xcode"
    echo "   - בחר את הפרויקט > Signing & Capabilities"
    echo "   - הגדר Development Team"
    echo ""
    echo "2. Bundle Identifier לא ייחודי:"
    echo "   - שנה את Bundle Identifier ל-com.yourname.AIAssistant"
    echo ""
    echo "3. גרסת Xcode ישנה:"
    echo "   - עדכן את Xcode דרך App Store"
    echo ""
    exit 1
fi 