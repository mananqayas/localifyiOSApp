//
//  AuthService.swift
//  localifyRedo
//
//  Created by Manan Qayas on 07/06/2025.
//

struct RegisterOwnerEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let email: String
    let fName: String
    let lName: String
    let password: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/owner/register"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    var parameters: [String : Any]? {
        [
            "email": email,
            "fName": fName,
            "password": password,
            "lName": lName
        ]
    }
    
    
}

struct GetUserEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let token: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/owner/profile"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json",
         "Authorization": "Bearer \(token)"]
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    
}

struct LoginUserEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let email: String
    let password: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        
        "/owner/login"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: [String : String]? {
        
        [
            "Content-Type": "application/json"
        ]
    }
    
    var parameters: [String : Any]? {
        [
            
            "email": email,
            "password": password
        ]
    }
    
    
}

import Foundation
class AuthService {
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func register(fName: String, lName: String, email: String, password: String) async -> Result<UserRegisterResponseModel, NetworkError> {
        UserDefaults.standard.removeObject(forKey: "localifyBusinessCreated")
        do {
            let response: UserRegisterResponseModel = try await networkManager.fetch(from: RegisterOwnerEndpoint(email: email, fName: fName, lName: lName, password: password))
      
            KeychainHelper.shared.save(response.token, forkey: "localifyToken")
            KeychainHelper.shared.save(response.owner.id, forkey: "ownerId")
            return .success(response)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.unknownError(-1))
        }
    }
    
    func getUser() async -> Result<UserResponse, NetworkError> {
        
        guard let token = KeychainHelper.shared.read("localifyToken") else { return .failure(.clientError(401))}
        do {
            let response: UserResponse = try await networkManager.fetch(from: GetUserEndpoint(token: token))
            return .success(response)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.unknownError(-1))
        }

    }
    
    func loginUser(email: String, password: String) async -> Result<UserRegisterResponseModel, NetworkError> {
        do {
            let response: UserRegisterResponseModel = try await networkManager.fetch(from: LoginUserEndpoint(email: email, password: password))
            KeychainHelper.shared.save(response.token, forkey: "localifyToken")
            KeychainHelper.shared.save(response.owner.id, forkey: "ownerId")
            return .success(response)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.unknownError(-1))
        }
    }
}
