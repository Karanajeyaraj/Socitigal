import Foundation
import UIKit

// MARK: - Registration Data
struct RegistrationData: Codable {
    let full_name: String
    let email_address: String
    let password: String
    let phone_number: String
    let tower: String
    let floor: String
    let flat_no: String
    let aadhar_no: String
    let usertype: String
    let mcode: String
}

// MARK: - Login Data
struct LoginRequest: Codable {
    let email_address: String
    let password: String
    let ip_address: String?
    let device_info: String?
    let login_time: String?
    let login_location: String?
    let usertype: String
}

// MARK: - API Service
class APIService {
    static let shared = APIService()

    // REGISTER USER
    func registerUser(data: RegistrationData, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://192.168.0.104:3000/register") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(data)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -2, userInfo: nil)))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                completion(.success("Registered Successfully"))
            } else {
                let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }.resume()
    }

    // LOGIN USER
    func loginUser(data: LoginRequest, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://192.168.0.104:3000/login") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(data)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  let responseData = data else {
                completion(.failure(NSError(domain: "NoResponse", code: -2, userInfo: nil)))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                if let result = try? JSONDecoder().decode([String: String].self, from: responseData),
                   let message = result["message"] {
                    completion(.success(message))
                } else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: -3, userInfo: nil)))
                }
            } else {
                let errorMsg = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMsg])))
            }
        }.resume()
    }
}

