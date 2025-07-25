//
//  EditLogoView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI
struct EditLogoView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var logoViewModel: LogoViewModel
    @State private var showLogoAddSheet: Bool = false
    @State private var showLibrary: Bool = false
    @State private var cameraType: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: UIImage?
    @State private var isUploading: Bool = false
    
    var body: some View {
        VStack {
            // header
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            dismiss()
                        }
                }
                .padding()
                Rectangle()
                    .fill(Color.localifyBorderColor)
                    .frame(height: 1)
            }
            // logo
            if let capturedImage = image {
                VStack {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .clipShape(Circle())
                    // upload and choose another buttons
                    HStack {
                        
                        Button {
                            isUploading = true
                            Task {
                                
                                if let logoImage = image {
                                    if logoViewModel.logoUrl?.isEmpty != false {
                                       let response =  await logoViewModel.uploadLogo(logo: logoImage)
                                        if response {
                                            isUploading = false
                                            image = nil
                                            Task {
                                                
                                                await logoViewModel.fetchLogo()
                                            }
                                        }
                                    } else {
                                        Task {
                                          let response =  await logoViewModel.updateLogo(logo: logoImage)
                                            if response {
                                                isUploading = false
                                                image = nil
                                                
                                                Task {
                                                    await logoViewModel.fetchLogo()
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                
                                
                            }
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.red)
                                .frame(height: 50)
                                .overlay {
                                    if isUploading {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text("Upload")
                                            .font(.poppins(.semiBold, size: 16))
                                            .foregroundStyle(.white)
                                    }
                                    
                                }
                                
                        }
                        .disabled(isUploading)
                        
                        Button {
                            
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.gray.opacity(0.2))
                                .frame(height: 50)
                                .overlay {
                                    Text("Choose another")
                                        .font(.poppins(.semiBold, size: 16))
                                        .foregroundStyle(isUploading ? .black.opacity(0.2) : .black)
                                    
                                }
                       
                               
                        }
                        .disabled(isUploading)

                    }
                    .padding()
                }
                .padding(.top, 20)
               
            } else if logoViewModel.isLoading {
                ProgressView()
            } else {
                VStack {

                    if let logoUrl = logoViewModel.logoUrl, !logoUrl.isEmpty {
                        // logoUrl is not empty
                        ZStack {
                            VStack {
                                AsyncImage(url: URL(string: logoUrl)) {phase in
                                    
                                    switch phase {
                                    case .empty:
                                        EmptyView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 200)
                                            .overlay {
                                                Circle()
                                                    .fill(Color.white.opacity(0.9))
                                                    .frame(width: 50)
                                                Image("editpencil")
                                            }
                                    case .failure(_):
                                          EmptyView()
                                    
                                        
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                Text("Change your logo")
                                    .font(.poppins(.semiBold, size: 18))
                                    .padding(.top, 10)
                            }
                          
                       
                        }
                    } else {
                        // logoUrl is empty or nil
                        Circle()
                            .frame(width: 200)
                            .foregroundStyle(Color.gray.opacity(0.2))
                            .overlay {
                                ZStack {
                                    Image("editlogo")
                                    Circle()
                                        .foregroundStyle(.white)
                                        .frame(width: 50)
                                    Circle()
                                        .stroke(Color.gray)
                                        .frame(width: 50)
                                    Image("editpencil")
                                }
                            }
                        Text("Upload your logo")
                            .font(.poppins(.semiBold, size: 18))
                            .padding(.top, 10)
                    }
                
                       
                }
                .padding(.top, 20)
                .onTapGesture {
                    showLogoAddSheet = true
                }
              
            }
            Spacer()
              
            }
        .onAppear {
            Task {
                
                await logoViewModel.fetchLogo()
            }
        }
        .confirmationDialog("Select logo", isPresented: $showLogoAddSheet) {
            Button("Select logo from library") {
                showLibrary = true
            }
        }
        .sheet(isPresented: $showLibrary) {
            ImagePicker(sourceType: cameraType, selectedImage: $image)
        }

    }
}

#Preview {
    let logoService = LogoService()
    let logoViewModel = LogoViewModel(logoService: logoService)

    EditLogoView()
        .environmentObject(logoViewModel)
}

