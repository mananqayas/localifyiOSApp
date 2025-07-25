//
//  AddNewPortfolioImageSheet.swift
//  localifyRedo
//
//  Created by Manan Qayas on 15/06/2025.
//

import SwiftUI

struct AddNewPortfolioImageSheet: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var cameraManager: CameraManager
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    @EnvironmentObject var navState: NavigationState
    @State private var isUploading: Bool = false
    var body: some View {
        VStack {
            
            // header
            VStack {
                HStack {
                    Text("Add an image")
                        .font(.poppins(.medium, size: 13))
                    Spacer()
                    Image(systemName: "xmark")
                        .onTapGesture {
                            cameraManager.stopSession()
                            cameraManager.capturedImage = nil
                            dismiss()
                        }
                }
                .padding(.horizontal)
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.localifyBorderColor)
            }
            if let image = cameraManager.capturedImage {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 400)
                    .padding()
                    .overlay {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding()
                            
                    }
                
                VStack {
                    Button {
                        isUploading = true
                        Task {
                            
                           let response =  await portfolioViewModel.uploadPortfolioImage(image: image)
                            if response {
                                isUploading = false
                                navState.selectedTab = 2
                                cameraManager.capturedImage = nil
                                dismiss()
                                
                                
                            }
                            
                        }
                        
                    } label: {
                        if isUploading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            
                            Text("Upload")
                        }
                    }
                    .buttonStyle(CustomButtonStyle())
                    
                    Button {
                        cameraManager.capturedImage = nil
                        cameraManager.startSession()
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 50)
                            .foregroundStyle(.gray.opacity(0.1))
                            .overlay {
                                Text("Retake")
                            }
                    }
                   
                }
                .padding()

              
                
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 400)
                    .padding()
                    .overlay {
                        CameraPreview(cameraManager: cameraManager)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding()
                
                VStack {
                    ZStack {
                        Circle()
                            .frame(width: 60)
                            .foregroundStyle(.red)
                        Circle()
                            .frame(width: 30)
                            .foregroundStyle(.white)
                    }
                    
                    Text("Capture image")
                        .foregroundStyle(.red)
                        .font(.poppins(.semiBold, size: 15))
                }
                .onTapGesture {
                    cameraManager.capturePhoto()
                }
            }
          
            
            Spacer()
        }
    }
}

#Preview {
    let cameraManager = CameraManager()
    let portfolioService = PortfolioService()
    let portfolioViewModel = PortfolioViewModel(portfolioService: portfolioService)
    let navState = NavigationState()
    AddNewPortfolioImageSheet()
        .environmentObject(cameraManager)
        .environmentObject(portfolioViewModel)
        .environmentObject(navState)
}
