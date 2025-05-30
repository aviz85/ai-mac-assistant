import Foundation
import AppKit

class TerminalExecutor {
    static let shared = TerminalExecutor()
    
    private init() {}
    
    func executeCommand(_ command: String, in directory: String, completion: @escaping (Result<String, Error>) -> Void) {
        // בדיקת בטיחות הפקודה
        guard isCommandSafe(command) else {
            completion(.failure(TerminalExecutorError.unsafeCommand))
            return
        }
        
        // הרצת הפקודה ב-background queue
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.runCommand(command, in: directory)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func showCommandConfirmation(command: String, filePath: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "אישור הרצת פקודה"
            alert.informativeText = """
            הפקודה הבאה עומדת להתבצע:
            
            \(command)
            
            בתיקייה: \(URL(fileURLWithPath: filePath).deletingLastPathComponent().path)
            
            האם אתה בטוח שברצונך להמשיך?
            """
            alert.alertStyle = .warning
            alert.addButton(withTitle: "הרץ")
            alert.addButton(withTitle: "ביטול")
            
            let response = alert.runModal()
            completion(response == .alertFirstButtonReturn)
        }
    }
    
    private func runCommand(_ command: String, in directory: String) -> Result<String, Error> {
        let process = Process()
        let pipe = Pipe()
        let errorPipe = Pipe()
        
        process.standardOutput = pipe
        process.standardError = errorPipe
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", "cd '\(directory)' && \(command)"]
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            
            if process.terminationStatus == 0 {
                let output = String(data: data, encoding: .utf8) ?? ""
                return .success(output)
            } else {
                let errorOutput = String(data: errorData, encoding: .utf8) ?? "Unknown error"
                return .failure(TerminalExecutorError.commandFailed(errorOutput))
            }
        } catch {
            return .failure(error)
        }
    }
    
    private func isCommandSafe(_ command: String) -> Bool {
        let dangerousCommands = [
            "rm -rf /",
            "sudo rm",
            "format",
            "mkfs",
            "dd if=",
            "> /dev/",
            "chmod 000",
            "chown root",
            "killall -9",
            "shutdown",
            "reboot",
            "halt"
        ]
        
        let lowercaseCommand = command.lowercased()
        
        // בדיקה אם הפקודה מכילה פקודות מסוכנות
        for dangerous in dangerousCommands {
            if lowercaseCommand.contains(dangerous.lowercased()) {
                return false
            }
        }
        
        // בדיקה נוספת לפקודות שמתחילות ב-sudo ללא אישור מפורש
        if lowercaseCommand.hasPrefix("sudo") && !lowercaseCommand.contains("sudo") {
            return false
        }
        
        return true
    }
    
    func getCommandPreview(_ command: String, filePath: String) -> String {
        let directory = URL(fileURLWithPath: filePath).deletingLastPathComponent().path
        return """
        פקודה: \(command)
        תיקייה: \(directory)
        קובץ נבחר: \(URL(fileURLWithPath: filePath).lastPathComponent)
        """
    }
}

enum TerminalExecutorError: LocalizedError {
    case unsafeCommand
    case commandFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .unsafeCommand:
            return "הפקודה נחשבת מסוכנת ולא תתבצע"
        case .commandFailed(let error):
            return "הפקודה נכשלה: \(error)"
        }
    }
} 