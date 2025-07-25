//
//  NetworkManager.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import Foundation
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
protocol Endpoint {
    var baseURL: URL {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var headers: [String: String]? {get}
    var parameters: [String: Any]? {get}
    var multipartBody: (data: Data, contentType: String)? {get}

}
extension Endpoint {
    
    func urlRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path.hasPrefix("/") ? String(path.dropFirst()) : path)
//        print("🔍 Constructed URL: \(url.absoluteString)")
//        print("🔍 Base URL: \(baseURL.absoluteString)")
//        print("🔍 Path: \(path)")
        var request = URLRequest(url: url)
       

        request.httpMethod = method.rawValue
        
        if let multipartBody = multipartBody {
            request.httpBody = multipartBody.data
            request.setValue(multipartBody.contentType, forHTTPHeaderField: "Content-Type")
            
            // Apply other headers too
            if let headers = headers {
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            return request // 🔥 very important: return early if multipart
        }
        
        // Non-multipart flow:
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let parameters = parameters {
            if method == .get {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.url = components?.url
            } else {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        
        return request
    }
}

protocol NetworkManaging {
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T
}


final class NetworkManager: NetworkManaging {
    
    static let shared = NetworkManager()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        let request = try endpoint.urlRequest()

        let (data, response) = try await session.data(for: request)
     
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        try validResponse(httpResponse)

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding failed for response: ", String(data: data, encoding: .utf8) ?? "nil")
            throw NetworkError.decodingFailed
        }
    }
    
    func validResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 404:
            return
        case 400...499:
            throw NetworkError.clientError(response.statusCode)
        case 500...599:
            throw NetworkError.serverError(response.statusCode)
            
        default:
            throw NetworkError.unknownError(response.statusCode)
        }
    }
    
}


enum NetworkError: Error {
    case invalidResponse
    case decodingFailed
    case clientError(Int)
    case serverError(Int)
    case unknownError(Int)
}
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .invalidResponse:
            return "Invalid response received from the server."
        case .decodingFailed:
            return "Failed to decode the response data."

        case .clientError(let statusCode):
            return "Client error occurred. Status code: \(statusCode)"
        case .serverError(let statusCode):
            return "Server error occured: Status code: \(statusCode)"

        case .unknownError(let statusCode):
            return "An unknown error occured: Status code: \(statusCode)"
            
        }
    }
}
