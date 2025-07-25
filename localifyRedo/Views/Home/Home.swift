//
//  Home.swift
//  localifyRedo
//
//  Created by Manan Qayas on 07/06/2025.
//
import SwiftUI

struct Home: View {
    @EnvironmentObject var navState: NavigationState
    
    var body: some View {
        VStack {
            VStack(spacing: 14) {
                HStack(spacing: 20) {
                    Text("Localify")
                        .font(.playball(size: 46))
                        .foregroundStyle(.red)
                    Text("for business")
                        .font(.poppins(.regular, size: 20))
                        .foregroundStyle(Color(red: 51/255, green: 51/255, blue: 51/255))
                }
             
                Text("By continuing you agree to Localify's Terms of Service and acknowlege Localify's Privacy Policy")
                    .multilineTextAlignment(.center)
                    .font(.poppins(.regular, size: 11))
                    .foregroundStyle(Color(red: 95/255, green: 88/255, blue: 88/255))
                
                // buttons
                VStack(spacing: 16) {
                    // sign up
                    Button {
                        navState.path.append(Route.signup)
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.red)
                            .frame(height: 40)
                            .overlay {
                                Text("Create a business account for free")
                                    .foregroundStyle(.white)
                                    .font(.poppins(.semiBold, size: 16))
                            }
                       
                    }
                    .buttonStyle(.plain)
                    
                    // login
                    Button {
                        navState.path.append(Route.login)
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 137/255, green: 128/255, blue: 128/255))
                            .frame(height: 40)
                            .overlay {
                                Text("Login to your business account")
                                    .foregroundStyle(Color(red: 51/255, green: 51/255, blue: 51/255))
                                    .font(.poppins(.semiBold, size: 16))
                            }
                       
                    }
                    .buttonStyle(.plain)

                }
                .padding(.top, 30)
            
            }
            .padding(.horizontal, 24)
            .padding(.top, 80)
         
            Spacer()
            HStack(spacing: 0) {
                Text("Need help? Contact us at")
                    .foregroundStyle(.gray)
                Text(" (123) 767-9357")
                    .foregroundStyle(.blue)
            }
            .font(.poppins(.light, size: 14))
        }
    }
}

#Preview {
    let navigationState  = NavigationState()
    Home()
        .environmentObject(navigationState)
}
