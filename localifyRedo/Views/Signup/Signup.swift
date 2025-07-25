//
//  Signup.swift
//  localifyRedo
//
//  Created by Manan Qayas on 07/06/2025.
//



import SwiftUI

struct Signup: View {
    @State private var fName: String = ""
    @State private var lName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var navState: NavigationState
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    var body: some View {
        VStack {
            NavHeader(title: "Sign up")
            
            // Fields VStack
            
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    SingleTextInputView(inputType: .text, text: $fName, placeholder: "First name")
                    SingleTextInputView(inputType: .text, text: $lName, placeholder: "Last name")
                }
                SingleTextInputView(inputType: .email, text: $email, placeholder: "Email address")
                InputPasswordField(text: $password)
                Button(authViewModel.isRegistering ? "Registering..." : "Create a business account for free") {
                    Task {
                        
                        let result =  await authViewModel.register(fName: fName, lName: lName, email: email, password: password)
                      
                        if result {
                            navState.path.append(Route.welcome)
                        } else {
                            
                            showError = true
                            
                        }
                    }
                }
                .buttonStyle(CustomButtonStyle())
                .disabled(fName.isEmpty || lName.isEmpty || email.isEmpty || password.isEmpty)
            }
            .alert(isPresented: $showError){
                Alert(
                    title: Text(authViewModel.errorMessage ?? "Some error")
                )
               
            }
            .padding()
            Spacer()
            // bottom
            Button {
//                navState.path.append(Route.login)
                
                
            } label: {
                HStack(spacing: 0) {
                     
                    Text("Already have a business account?")
                    Text(" Log in")
                        .foregroundStyle(Color(red: 96/255, green: 96/255, blue: 218/255 ))
                }
                .font(.poppins(.regular, size: 15))
                .tint(.gray)
            }
        }
   
        
    }
}

#Preview {
    let navState = NavigationState()
    let authService = AuthService()
    let authViewModel = AuthViewModel(authService: authService)
    NavigationStack {
        Signup()
            .environmentObject(navState)
            .environmentObject(authViewModel)
    }
}



