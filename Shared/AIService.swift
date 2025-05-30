import Foundation

class AIService {
    static let shared = AIService()
    
    private let baseURL = "https://api.anthropic.com/v1/messages"
    private let model = "claude-3-sonnet-20240229"
    
    private init() {}
    
    func testConnection(completion: @escaping (Bool, Error?) -> Void) {
        guard let apiKey = getAPIKey() else {
            completion(false, AIServiceError.noAPIKey)
            return
        }
        
        let testPrompt = "Hello, please respond with 'Connection successful'"
        
        sendRequest(prompt: testPrompt, filePath: nil) { result in
            switch result {
            case .success:
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    func generateCommand(for prompt: String, filePath: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let apiKey = getAPIKey() else {
            completion(.failure(AIServiceError.noAPIKey))
            return
        }
        
        let systemPrompt = createSystemPrompt(filePath: filePath)
        let fullPrompt = "\(systemPrompt)\n\nUser request: \(prompt)"
        
        sendRequest(prompt: fullPrompt, filePath: filePath, completion: completion)
    }
    
    private func createSystemPrompt(filePath: String) -> String {
        let fileName = URL(fileURLWithPath: filePath).lastPathComponent
        let fileExtension = URL(fileURLWithPath: filePath).pathExtension
        
        return """
        You are a macOS terminal command generator. Your task is to translate user requests into safe, executable terminal commands.
        
        Context:
        - Selected file: \(fileName)
        - File path: \(filePath)
        - File extension: \(fileExtension)
        - Current directory: \(URL(fileURLWithPath: filePath).deletingLastPathComponent().path)
        
        Rules:
        1. Generate ONLY the terminal command, no explanations
        2. Use relative paths when possible
        3. Ensure commands are safe (no rm -rf /, no sudo without explicit request)
        4. For file operations, always reference the selected file
        5. If the request is unclear or dangerous, respond with "UNSAFE_COMMAND"
        
        Examples:
        - "open this file" → "open '\(fileName)'"
        - "copy this file to desktop" → "cp '\(fileName)' ~/Desktop/"
        - "show file info" → "ls -la '\(fileName)'"
        - "compress this file" → "zip '\(fileName).zip' '\(fileName)'"
        """
    }
    
    private func sendRequest(prompt: String, filePath: String?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let apiKey = getAPIKey() else {
            completion(.failure(AIServiceError.noAPIKey))
            return
        }
        
        guard let url = URL(string: baseURL) else {
            completion(.failure(AIServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        let requestBody: [String: Any] = [
            "model": model,
            "max_tokens": 1000,
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(AIServiceError.noData))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let content = json["content"] as? [[String: Any]],
                   let firstContent = content.first,
                   let text = firstContent["text"] as? String {
                    
                    let command = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    completion(.success(command))
                } else {
                    completion(.failure(AIServiceError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func getAPIKey() -> String? {
        return UserDefaults.standard.string(forKey: "ClaudeAPIKey")
    }
}

enum AIServiceError: LocalizedError {
    case noAPIKey
    case invalidURL
    case noData
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "API Key לא נמצא. אנא הגדר API Key באפליקציה הראשית."
        case .invalidURL:
            return "כתובת URL לא תקינה"
        case .noData:
            return "לא התקבלו נתונים מהשרת"
        case .invalidResponse:
            return "תגובה לא תקינה מהשרת"
        }
    }
} 