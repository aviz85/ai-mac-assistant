import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var apiKeyTextField: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var testButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSavedAPIKey()
    }
    
    private func setupUI() {
        statusLabel.stringValue = "הגדר את ה-API Key של Claude כדי להתחיל"
        
        // בדיקת סטטוס ההרחבה
        checkExtensionStatus()
    }
    
    private func loadSavedAPIKey() {
        if let savedKey = UserDefaults.standard.string(forKey: "ClaudeAPIKey") {
            apiKeyTextField.stringValue = savedKey
            statusLabel.stringValue = "API Key נשמר בהצלחה"
        }
    }
    
    @IBAction func saveAPIKey(_ sender: NSButton) {
        let apiKey = apiKeyTextField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !apiKey.isEmpty else {
            showAlert(title: "שגיאה", message: "אנא הזן API Key תקין")
            return
        }
        
        // שמירת ה-API Key
        UserDefaults.standard.set(apiKey, forKey: "ClaudeAPIKey")
        statusLabel.stringValue = "API Key נשמר בהצלחה!"
        
        // בדיקת החיבור
        testConnection()
    }
    
    @IBAction func testConnection(_ sender: NSButton) {
        testConnection()
    }
    
    private func testConnection() {
        guard let apiKey = UserDefaults.standard.string(forKey: "ClaudeAPIKey"),
              !apiKey.isEmpty else {
            showAlert(title: "שגיאה", message: "אנא הגדר API Key תחילה")
            return
        }
        
        statusLabel.stringValue = "בודק חיבור..."
        testButton.isEnabled = false
        
        // כאן נבדוק את החיבור ל-Claude API
        AIService.shared.testConnection { [weak self] success, error in
            DispatchQueue.main.async {
                self?.testButton.isEnabled = true
                if success {
                    self?.statusLabel.stringValue = "החיבור תקין! ההרחבה מוכנה לשימוש"
                } else {
                    self?.statusLabel.stringValue = "שגיאה בחיבור: \(error?.localizedDescription ?? "שגיאה לא ידועה")"
                }
            }
        }
    }
    
    private func checkExtensionStatus() {
        // בדיקת סטטוס הרחבת Finder
        // כאן נוסיף קוד לבדיקה אם ההרחבה מותקנת ופעילה
    }
    
    private func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "אישור")
        alert.runModal()
    }
} 