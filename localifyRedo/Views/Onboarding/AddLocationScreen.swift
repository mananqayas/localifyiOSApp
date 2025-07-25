//
//  AddLocationScreen.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import SwiftUI

struct AddLocationScreen: View {
    @State private var showToast: Bool = true
    @EnvironmentObject private var navState: NavigationState
    @EnvironmentObject private var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            //header
            VStack(spacing: 10) {
                ZStack(alignment: .top) {
                    HStack {
                        Spacer()
                            Text("Logout")
                      
                        .foregroundStyle(Color.localifyGray)
                        .font(.poppins(.regular, size: 16))
                        
                            .onTapGesture {
                                authViewModel.logout()
                                navState.path.removeLast(navState.path.count)
                            }
                    
                       
                    }
                    HStack {
                        Text("Welcome \(authViewModel.loggedInUser?.fName ?? "")")
                            .foregroundStyle(Color.localifyGray)
                            .font(.poppins(.regular, size: 16))
                    }
                }
                .padding(.horizontal)
                Rectangle()
                    .foregroundStyle(Color.localifyBorderColor)
                    .frame(height: 1)
                
            }
            
            
            VStack {
                if showToast {
                    Toast()
                      
                }
              
            }
            .animation(.spring(), value: showToast)
            .padding()
            
            VStack(spacing: 30) {
                Image("welcome")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                VStack {
                    Text("Add your location")
                        .font(.poppins(.semiBold, size: 26))
                    Text("In order to  manage your business, add a location; it’s free and only takes a minute.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.localifyGray)
                        .font(.poppins(.light, size: 15))
                }
                .padding(.horizontal)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showToast = false
                    }
                }
            }
            
    
            
            Spacer()
            Button("Add a location") {
                navState.path.append(Route.locationFields)
            }
            .buttonStyle(CustomButtonStyle())
            .padding()
            
        }
    }
}

#Preview {
    let navState = NavigationState()
    let authService = AuthService()
    let authViewModel = AuthViewModel(authService: authService)
    AddLocationScreen()
        .environmentObject(navState)
        .environmentObject(authViewModel)
}
