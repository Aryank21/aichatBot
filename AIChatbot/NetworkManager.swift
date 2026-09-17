//
//  NetworkManager.swift
//  AIChatbot
//
//  Created by Aryan iOS on 07/04/26.
//

import Foundation

class NetworkManager {

    // Put your NEW Groq API key here
    let apiKey = ""

    func sendMessage(message: String, completion: @escaping (String) -> Void) {

        guard let url = URL(string: "https://api.groq.com/openai/v1/chat/completions") else {
            completion("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "openai/gpt-oss-20b",
            "messages": [
                [
                    "role": "user",
                    "content": message
                ]
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion("Failed to create request: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion("Network Error: \(error.localizedDescription)")
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code:", httpResponse.statusCode)
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion("No response from server")
                }
                return
            }

            // Print raw response for debugging
            print("Groq Response:", String(data: data, encoding: .utf8) ?? "Invalid response")

            do {

                guard let result = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    DispatchQueue.main.async {
                        completion("Invalid server response")
                    }
                    return
                }

                // Check API error
                if let errorObject = result["error"] as? [String: Any],
                   let errorMessage = errorObject["message"] as? String {

                    DispatchQueue.main.async {
                        completion("API Error: \(errorMessage)")
                    }
                    return
                }

                guard
                    let choices = result["choices"] as? [[String: Any]],
                    let firstChoice = choices.first,
                    let messageObject = firstChoice["message"] as? [String: Any],
                    let content = messageObject["content"] as? String
                else {
                    DispatchQueue.main.async {
                        completion("Could not read AI response")
                    }
                    return
                }

                DispatchQueue.main.async {
                    completion(content)
                }

            } catch {
                DispatchQueue.main.async {
                    completion("JSON Error: \(error.localizedDescription)")
                }
            }

        }.resume()
    }
}
