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

// MARK: - Login Response
struct LoginResponse: Codable {
    let success: Bool?
    let message: String
}

class APIService {
    static let shared = APIService()

    // MARK: - Helper Method to Create Request
    private func makeRequest<T: Codable>(urlString: String, payload: T) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "InvalidURL", code: -1, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(payload)

        return request
    }

    // MARK: - Register User
    func registerUser(data: RegistrationData, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let request = try makeRequest(urlString: "http://rjt.4ec.mytemp.website/SocietyManagementAPI/register.php", payload: data)

            URLSession.shared.dataTask(with: request) { data, response, error in
                self.handleResponse(data: data, response: response, error: error, completion: completion)
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Login User
    func loginUser(data: LoginRequest, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let request = try makeRequest(urlString: "http://rjt.4ec.mytemp.website/SocietyManagementAPI/login.php", payload: data)

            URLSession.shared.dataTask(with: request) { data, response, error in
                self.handleLoginResponse(data: data, response: response, error: error, completion: completion)
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - General Response Handler
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<String, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse,
              let responseData = data else {
            completion(.failure(NSError(domain: "InvalidResponse", code: -2, userInfo: nil)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            let message = String(data: responseData, encoding: .utf8) ?? "Success"
            completion(.success(message))
        } else {
            let errorMsg = String(data: responseData, encoding: .utf8) ?? "Unknown error"
            completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMsg])))
        }
    }

    // MARK: - Login Response Handler with JSON Decoding
    private func handleLoginResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<String, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse,
              let responseData = data else {
            completion(.failure(NSError(domain: "InvalidResponse", code: -2, userInfo: nil)))
            return
        }

        print("📡 Status Code: \(httpResponse.statusCode)")
        print("📦 Raw Response: \(String(data: responseData, encoding: .utf8) ?? "nil")")

        if (200...299).contains(httpResponse.statusCode) {
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: responseData)
                completion(.success(loginResponse.message))
            } catch {
                let fallback = String(data: responseData, encoding: .utf8) ?? "Login succeeded"
                completion(.success(fallback))
            }
        } else {
            let errorMsg = String(data: responseData, encoding: .utf8) ?? "Login failed"
            completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMsg])))
        }
    }
}

