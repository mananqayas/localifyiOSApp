//
//  Login.swift
//  localifyRedo
//
//  Created by Manan Qayas on 07/06/2025.
//

import SwiftUI

struct Login: View {
    @EnvironmentObject var navState: NavigationState
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var showAlert: Bool = false
    @AppStorage("localifyBusinessCreated") private var isCreatedBusiness: Bool?
    

    var body: some View {
        VStack {
            NavHeader(title: "Log in")
            // Fields VStack
            
            VStack(spacing: 20) {
            
                SingleTextInputView(inputType: .email, text: $email, placeholder: "Email address")
                InputPasswordField(text: $password)
                Button(authViewModel.isRegistering ? "Logging in..." : "Login to your business account") {
                    Task {
                      let response =  await authViewModel.loginUser(email: email, password: password)
                        
                        if !response {
                            showAlert = true
                        } else {
                            if isCreatedBusiness == true {
                                navState.path.append(Route.tabView)
                            } else {
                                navState.path.append(Route.welcome)
                            }
                        }
                        
                        
                    }
                }
                .buttonStyle(CustomButtonStyle())
                .disabled(email.isEmpty || password.isEmpty)
            }
            .alert("Cannot login", isPresented: $showAlert, actions: {
                Button(role: .cancel) {
                    
                } label: {
                    Text("Cancel")
                }

            })
            .padding()
            Spacer()
            // bottom
            Button {
                navState.path.append(Route.signup)
                
            } label: {
                HStack(spacing: 0) {
                    Text("Don’t have a business account?")
                    Text(" Sign up")
                        .foregroundStyle(Color(red: 96/255, green: 96/255, blue: 218/255 ))
                }
                .font(.poppins(.regular, size: 15))
                .tint(.gray)
            }
        }
    }
}

#Preview {
    
    let authService = AuthService()
    let authViewModel = AuthViewModel(authService: authService)

    Login()
        .environmentObject(authViewModel)

}
