import Cocoa
import FinderSync

class FinderSync: FIFinderSync {
    
    override init() {
        super.init()
        
        // הגדרת התיקיות שההרחבה תפעל בהן (כל התיקיות)
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }
    
    // MARK: - Primary Finder Sync protocol methods
    
    override func beginObservingDirectory(at url: URL) {
        // התחלת מעקב אחר תיקייה
    }
    
    override func endObservingDirectory(at url: URL) {
        // סיום מעקב אחר תיקייה
    }
    
    override func requestBadgeIdentifier(for url: URL) {
        // בקשה לתג על קובץ/תיקייה
    }
    
    // MARK: - Menu and toolbar item support
    
    override var toolbarItemName: String {
        return "AI Assistant"
    }
    
    override var toolbarItemToolTip: String {
        return "הפעל AI Assistant על הקובץ הנבחר"
    }
    
    override var toolbarItemImage: NSImage {
        return NSImage(systemSymbolName: "brain", accessibilityDescription: "AI Assistant") ?? NSImage()
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        let menu = NSMenu(title: "")
        
        switch menuKind {
        case .contextualMenuForItems:
            // תפריט קליק ימני על קבצים
            let aiMenuItem = NSMenuItem(title: "AI Assistant", action: #selector(showAIPrompt(_:)), keyEquivalent: "")
            aiMenuItem.image = NSImage(systemSymbolName: "brain", accessibilityDescription: "AI Assistant")
            menu.addItem(aiMenuItem)
            
        case .contextualMenuForContainer:
            // תפריט קליק ימני על תיקיות ריקות
            break
            
        case .contextualMenuForSidebar:
            // תפריט בסרגל הצד
            break
            
        case .toolbarItemMenu:
            // תפריט כלי העבודה
            let aiMenuItem = NSMenuItem(title: "הפעל AI Assistant", action: #selector(showAIPrompt(_:)), keyEquivalent: "")
            menu.addItem(aiMenuItem)
            
        @unknown default:
            break
        }
        
        return menu
    }
    
    @IBAction func showAIPrompt(_ sender: AnyObject?) {
        guard let selectedItems = FIFinderSyncController.default().selectedItemURLs(),
              let firstItem = selectedItems.first else {
            showAlert(title: "שגיאה", message: "אנא בחר קובץ תחילה")
            return
        }
        
        // בדיקה אם API Key מוגדר
        guard UserDefaults.standard.string(forKey: "ClaudeAPIKey") != nil else {
            showAlert(title: "הגדרה נדרשת", message: "אנא הגדר API Key באפליקציה הראשית תחילה")
            return
        }
        
        showPromptDialog(for: firstItem)
    }
    
    private func showPromptDialog(for fileURL: URL) {
        let alert = NSAlert()
        alert.messageText = "AI Assistant"
        alert.informativeText = "מה תרצה לעשות עם הקובץ '\(fileURL.lastPathComponent)'?"
        alert.alertStyle = .informational
        
        // יצירת text field לפרומפט
        let inputTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        inputTextField.placeholderString = "לדוגמה: פתח את הקובץ, העתק לשולחן העבודה, דחס..."
        alert.accessoryView = inputTextField
        
        alert.addButton(withTitle: "הפעל")
        alert.addButton(withTitle: "ביטול")
        
        let response = alert.runModal()
        
        if response == .alertFirstButtonReturn {
            let prompt = inputTextField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !prompt.isEmpty else {
                showAlert(title: "שגיאה", message: "אנא הזן בקשה")
                return
            }
            
            processAIRequest(prompt: prompt, fileURL: fileURL)
        }
    }
    
    private func processAIRequest(prompt: String, fileURL: URL) {
        // הצגת אינדיקטור טעינה
        let progressAlert = createProgressAlert()
        
        AIService.shared.generateCommand(for: prompt, filePath: fileURL.path) { [weak self] result in
            DispatchQueue.main.async {
                progressAlert.window.close()
                
                switch result {
                case .success(let command):
                    self?.handleGeneratedCommand(command, fileURL: fileURL)
                case .failure(let error):
                    self?.showAlert(title: "שגיאה", message: "לא ניתן ליצור פקודה: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func handleGeneratedCommand(_ command: String, fileURL: URL) {
        // בדיקה אם הפקודה בטוחה
        if command == "UNSAFE_COMMAND" {
            showAlert(title: "פקודה לא בטוחה", message: "הבקשה שלך לא יכולה להתבצע מסיבות בטיחות")
            return
        }
        
        // הצגת הפקודה למשתמש לאישור
        TerminalExecutor.shared.showCommandConfirmation(command: command, filePath: fileURL.path) { [weak self] confirmed in
            if confirmed {
                self?.executeCommand(command, fileURL: fileURL)
            }
        }
    }
    
    private func executeCommand(_ command: String, fileURL: URL) {
        let directory = fileURL.deletingLastPathComponent().path
        
        TerminalExecutor.shared.executeCommand(command, in: directory) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let output):
                    if !output.isEmpty {
                        self?.showAlert(title: "הפקודה הושלמה", message: output)
                    } else {
                        self?.showAlert(title: "הפקודה הושלמה", message: "הפקודה בוצעה בהצלחה")
                    }
                case .failure(let error):
                    self?.showAlert(title: "שגיאה", message: "הפקודה נכשלה: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func createProgressAlert() -> NSAlert {
        let alert = NSAlert()
        alert.messageText = "מעבד בקשה..."
        alert.informativeText = "AI מתרגם את הבקשה שלך לפקודת terminal"
        alert.alertStyle = .informational
        
        let progressIndicator = NSProgressIndicator(frame: NSRect(x: 0, y: 0, width: 200, height: 20))
        progressIndicator.style = .bar
        progressIndicator.isIndeterminate = true
        progressIndicator.startAnimation(nil)
        alert.accessoryView = progressIndicator
        
        // הצגה ללא כפתורים (יסגר אוטומטית)
        DispatchQueue.main.async {
            alert.runModal()
        }
        
        return alert
    }
    
    private func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "אישור")
        alert.runModal()
    }
} 