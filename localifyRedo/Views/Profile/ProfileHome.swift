//
//  ProfileHome.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import SwiftUI

struct ProfileHome: View {
    @State private var fName: String = "John"
    @State private var lName: String = "Doe"
    @State private var email: String = "john@gmail.com"
    
    @State private var showImagePicker = false
    @State private var image: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showSourceMenu = false
    @EnvironmentObject var userViewModel: UserViewModel
    
    @EnvironmentObject  var authViewModel: AuthViewModel
    @EnvironmentObject var navState: NavigationState
    
        var body: some View {
            VStack {
                // Header
                VStack{
                    HStack(spacing: 20) {
                        ZStack {
                            if userViewModel.isLoading {
                                ZStack {
                                    Circle()
                                        .frame(width: 70)
                                        .foregroundStyle(.gray.opacity(0.1))
                                    Text("Loading")
                                        .font(.caption)
                                  
                                }
                            } else {
                                if let url  = userViewModel.imageUrl, let imageUrl = URL(string: url) {
                                    AsyncImage(url: imageUrl) {phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 70, height: 70)
                                                .clipShape(Circle())
                                            
                                        case .failure(_):
                                            Circle()
                                                .frame(width: 70)
                                                .foregroundStyle(.gray.opacity(0.1))
                                            Image(systemName: "person")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 30)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                  
                                            
                                        
                                      
                                    
                                
                                } else {
                                    ZStack {
                                        Circle()
                                            .frame(width: 70)
                                            .foregroundStyle(.gray.opacity(0.1))
                                        Image(systemName: "person")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                    }
                                  
                
                                }
                            }
                         
                        }
                        .onAppear {
                            Task {
                           
                                    
                                await userViewModel.getProfileImage()
                                
                            }
                        }
                        .onTapGesture {
                            showSourceMenu = true
                        }
                        Text("\(authViewModel.loggedInUser?.fName ?? "fName") \(authViewModel.loggedInUser?.lName ?? "lName")")
                            .font(.poppins(.semiBold, size: 18))
                        Spacer()
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .font(.poppins(.light, size: 15))
                            .onTapGesture {
                                
                                authViewModel.logout()
                                navState.selectedTab = 0
                                navState.path.removeLast(navState.path.count)
                            }
                      
                    }
                    .padding()
                    Divider()
                }
                // your details, first, last and email fields
                VStack(alignment: .leading , spacing: 30) {
                
                    VStack(alignment: .leading) {
                        Text("Your details")
                            .font(.poppins(.semiBold, size: 22))
                            .padding(.bottom, 10)
                        
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray)
                            .frame(height: 50)
                            .overlay {
                                HStack {
                                    Text(authViewModel.loggedInUser?.fName ?? "first")
                                        .foregroundStyle(.gray)
                                        .padding(.horizontal)
                                    
                                    Spacer()
                                }
                            }
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray)
                            .frame(height: 50)
                            .overlay {
                                HStack {
                                    Text(authViewModel.loggedInUser?.lName ?? "last")
                                        .foregroundStyle(.gray)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                            }
                            

                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray)
                            .frame(height: 50)
                            .overlay {
                                HStack {
                                    Text(authViewModel.loggedInUser?.email ?? "test@gmail.com")
                                        .foregroundStyle(.gray)
                                        .padding(.horizontal)
                                    
                                    Spacer()
                                }
                            }
                            

                            

                    }

                }
                .padding(.top, 30)
                .padding(.horizontal)
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .confirmationDialog("Select Photo Source", isPresented: $showSourceMenu) {
                Button("Take Photo") {
                    sourceType = .camera
                    showImagePicker = true
                }
                Button("Choose from Library") {
                    sourceType = .photoLibrary
                    showImagePicker = true
                }
                Button("Cancel", role: .cancel){}
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: sourceType, selectedImage: $image)
            }
            .onChange(of: image) { oldValue, newValue in
                if let image = newValue {
                    Task {
                        
                        await userViewModel.upload(image: image)
                    }
                }
            }
        }
    }


#Preview {
    let navState = NavigationState()
    let authService = AuthService()
    let authViewModel = AuthViewModel(authService: authService)
    let userService = UserService()
    let userViewModel = UserViewModel(userService: userService)
    ProfileHome()
        .environmentObject(authViewModel)
        .environmentObject(userViewModel)
}
