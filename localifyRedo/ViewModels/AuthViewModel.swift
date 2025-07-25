//
//  AuthViewModel.swift
//  localifyRedo
//
//  Created by Manan Qayas on 07/06/2025.
//

import Foundation
@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    @Published var loggedInUser: UserResponse?
    @Published var isRegistering: Bool = false
    let authService: AuthService
    init(authService: AuthService){

        self.authService = authService
        Task {
            
            await getUser()
        }
     
    }
    
    func register(fName: String, lName: String, email: String, password: String) async -> Bool {
        isRegistering = true
        let result = await authService.register(fName: fName, lName: lName, email: email, password: password)
        
        switch result {
            
        case .success(let user):
            isRegistering = false
            self.loggedInUser = user.owner
            return true
        case .failure(let error):
       
            errorMessage = error.localizedDescription
            isRegistering = false
            return false
        }
        
   
    }
    
    
    func loginUser(email: String, password: String) async -> Bool {
        isRegistering = true
        let result = await authService.loginUser(email: email, password: password)
        
        switch result {
            
        case .success(let response):
            loggedInUser = response.owner
            isLoggedIn = true
            isRegistering = false
            return true
        case .failure(let error):
            let _ = error
            errorMessage = "Cannot login"
            isRegistering = false
            return false
        }
        
    }
    
    
    func getUser() async -> Bool {
        
        let result = await authService.getUser()
        
        switch result {
        case .success(let response):
            isLoggedIn = true
            isLoading = false
            
            self.loggedInUser = response
    
            return true
        case .failure( let error):
            
            let _ = error
            isLoggedIn = false
            isLoading = false
            return false
        }
        
    }
    
    func logout() {
        
        KeychainHelper.shared.delete("localifyToken")
        isLoggedIn = false
    }
    
}
