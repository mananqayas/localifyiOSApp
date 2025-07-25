//
//  CameraView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 14/06/2025.
//

import SwiftUI
// MARK: - Main View

struct CameraView: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var showCamera = false
    @State private var showCancel: Bool = false

    var body: some View {
        VStack(spacing: 20) {

            // Button to show camera
            Button {
                showCamera = true
                cameraManager.startSession()
         
                
            } label: {
              Text("Take photo")
            }
            .buttonStyle(CustomButtonStyle())
            .padding()
          
       
                

            // Show captured image
            if let image = cameraManager.capturedImage {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray)
                    .frame(height: 200)
                    .overlay(
                        ZStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Button {
                                cameraManager.capturedImage = nil
                                cameraManager.startSession()
                                showCamera = true
                            } label: {
                                Text("Reupload")
                            }
                        }
                    )
            }

        }
//        .sheet(isPresented: $showCamera) {
//            ZStack {
//                Color.black.ignoresSafeArea()
//
//                VStack {
//                    // Live camera preview inside Rounded Rectangle
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.white, lineWidth: 2)
//                        .frame(height: 400)
//                        .overlay(
//                            CameraPreview(cameraManager: cameraManager)
//                                .clipShape(RoundedRectangle(cornerRadius: 8))
//                        )
//                        .padding()
//
//                    // Capture button
//                    Button(action: {
//                        cameraManager.capturePhoto()
//                        showCamera = false
//                    }) {
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 70, height: 70)
//                            .shadow(radius: 10)
//                    }
//                    .padding(.top, 20)
//
//                    Spacer()
//                }
//            }
//            .onDisappear {
//                cameraManager.stopSession()
//            }
//        }
        .fullScreenCover(isPresented: $showCamera) {
            ZStack {
                // bottom
                VStack {
            
                    HStack {
                        Image(systemName: "chevron.left")
                            .onTapGesture {
                                showCamera = false
                            }
                        Spacer()
                        Image(systemName: "xmark")
                            .onTapGesture {
                                showCancel = true
                            }
                            
                    }
                    .padding(.horizontal)
                    RoundedRectangle(cornerRadius: 8)
                                         .stroke(Color.white, lineWidth: 2)
                                         .frame(height: 400)
                                         .overlay(
                                            ZStack {
                                                CameraPreview(cameraManager: cameraManager)
                                                    .overlay {
                                                        Text("HELLO")
                                                    }
                                                
                                         
                                            }
                                         )
                                         .padding()
                    
                    Button(action: {
                                      cameraManager.capturePhoto()
                                      showCamera = false
                                  }) {
                                      Circle()
                                          .fill(Color.white)
                                          .frame(width: 70, height: 70)
                                          .shadow(radius: 10)
                                  }
                                  .padding(.top, 20)
                    
                    Spacer()
                }
                
                if showCancel {
                    // top
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.black.opacity(0.6))
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.white)
                            .frame(height: 300)
                            .padding(.horizontal, 2)
                            .transition(.slide)
                            .animation(.easeInOut, value: showCancel)
                            .overlay {
                                VStack(alignment: .leading) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Cancel verification")
                                            .font(.poppins(.semiBold, size: 28))
                                        Text("Are you sure you want to cancel?")
                                            .font(.poppins(.light, size: 15))
                                    }
                                    Button {
                                        showCamera = false
                                        showCancel = false
                                    } label: {
                                         
                                        Capsule()
                                            .foregroundStyle(.red)
                                            .frame(height: 50)
                                           
                                            .overlay {
                                                Text("Cancel")
                                                    .font(.poppins(.bold, size: 15))
                                                    .foregroundStyle(.white)
                                            }
                                    }
                                    .padding(.top, 20)
                                    Button {
                                   
                                        showCancel = false
                                    } label: {
                                         
                                        Capsule()
                                            .foregroundStyle(.gray.opacity(0.1))
                                            .frame(height: 50)
                                           
                                            .overlay {
                                                Text("Resume")
                                                    .font(.poppins(.bold, size: 15))
                                                    .foregroundStyle(.black)
                                            }
                                    }
                                    .padding(.top, 10)
                                    
                                }
                                .padding()
                            }
                       
                    }
                
                    .onTapGesture {
                        withAnimation {
                            showCancel = false
                        }
                    }
                }
               
            
                
                
            }
        }
    }
}

// MARK:

#Preview {
    CameraView()
}
