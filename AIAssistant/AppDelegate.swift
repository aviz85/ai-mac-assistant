import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // הגדרת האפליקציה
        setupApplication()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // ניקוי לפני סגירה
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    private func setupApplication() {
        // בדיקה אם ההרחבה מותקנת ופעילה
        checkExtensionStatus()
    }
    
    private func checkExtensionStatus() {
        // כאן נבדוק את סטטוס ההרחבה ונציג הודעה למשתמש אם נדרש
        print("בודק סטטוס הרחבת Finder...")
    }
} 