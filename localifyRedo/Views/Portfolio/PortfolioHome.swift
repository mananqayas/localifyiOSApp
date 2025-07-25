//
//  PortfolioHome.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//



import SwiftUI
struct PortfolioImage: View {
    let image: PortfolioModel
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
        .foregroundStyle(.white)
            .frame(height: 100)
            .overlay {
                ZStack {
                    AsyncImage(url: URL(string: image.url)) {image in
                    image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 100)
                          
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        
                    } placeholder: {
                        ProgressView()
                    }
                    Image("recycleIcon")
                        .frame(width: 80, height: 80)
                        .onTapGesture {
                            print("deleting...")
                        }
                }
              
            }
    }
}

struct AddImage: View {
    @State private var isPressed = false
    @State var cameraMenu: Bool = false
    @State var cameraSource: UIImagePickerController.SourceType = .camera
    @State var showImageSourceSheet: Bool = false
    @State var selectedImage: UIImage?
    @Binding var showCamera: Bool
    @EnvironmentObject var cameraManager: CameraManager

    var body: some View {
        
        RoundedRectangle(cornerRadius: 4)
           .strokeBorder(isPressed ? .blue : Color.localifyBorderColor, style: StrokeStyle(dash: [5]))
           .frame(height: 100)
           .overlay {
               Image("addPortfolioImage")
                   .resizable()
                   .scaledToFit()
                   .frame(width: 30)
           }
           .scaleEffect(isPressed ? 0.95 : 1.0)
           .animation(.easeInOut(duration: 0.2), value: isPressed)
           .gesture(
               DragGesture(minimumDistance: 0)
                   .onChanged { _ in isPressed = true }
                   .onEnded { _ in
                       showCamera = true
                       cameraManager.startSession()
                   }
               
           )
   
    }
}


struct PortfolioHome: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var showCamera = false
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    @State private var isUploading: Bool = false
    @State private var showSuccess: Bool = false
    @State private var showAlert: Bool = false


    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
        
    ]


    
    var body: some View {
        ZStack {
            if showCamera {
                VStack {
                    // Header
                    VStack {
                        Text("Portfolio")
                            .foregroundStyle(Color.localifyGray)
                        Rectangle()
                            .fill(Color.localifyBorderColor)
                            .frame(height: 2)
                    }
                    RoundedRectangle(cornerRadius: 8)
                                         .stroke(Color.white, lineWidth: 2)
                                         .frame(height: 400)
                                         .overlay(
                                            ZStack {
                                                CameraPreview(cameraManager: cameraManager)
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                                    .overlay (
                                                        
                                                        Text("Cancel")
                                                            .padding()
                                                            .foregroundStyle(.white)
                                                            .font(.poppins(.bold, size: 18))
                                                            .onTapGesture {
                                                                showCamera = false
                                                                cameraManager.stopSession()
                                                            }
                                                        
                                                        , alignment: .topTrailing)
                                                  
                                                
                                         
                                            }
                                         )
                                         .padding()
                    
                    
                    Button(action: {
                                      cameraManager.capturePhoto()
                                      showCamera = false
                                  }) {
                                      Circle()
                                          .fill(Color.red)
                                          .frame(width: 70, height: 70)
                                          .shadow(radius: 10)
                                          .overlay {
                                              Circle()
                                                  .fill(Color.white)
                                                  .frame(height: 40)
                                          }
                                  }
                                  .padding(.top, 20)
                    
                    Spacer()
                }
          
            } else {
                VStack(spacing: 0) {
                    // Header
                    VStack {
                        Text("Portfolio")
                            .foregroundStyle(Color.localifyGray)
                        Rectangle()
                            .fill(Color.localifyBorderColor)
                            .frame(height: 2)
                    }
                    VStack {
                        
                        if let image = cameraManager.capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding()
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y:5)
                         
                              
                            
                            
                            VStack {
                                Button {
                                    isUploading = true
                                    Task {
                                        let response = await portfolioViewModel.uploadPortfolioImage(image: image)
                                        if response {
                                            isUploading = false
                                            cameraManager.capturedImage = nil
                                            cameraManager.stopSession()
                                            Task {
                                                
                                                await portfolioViewModel.fetchAllPortfolioImages()
                                            }
                                            showCamera = false
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
                                    showCamera = true
                                } label: {
                                    Text("Retake")
                                }
                                .disabled(isUploading)
                            }
                            .padding()

                               
                        } else if  portfolioViewModel.allPortfolioImages.isEmpty {
                            Image("noImagesFound")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300)
                            Text("No images found")
                                .font(.poppins(.medium, size: 26))
                            Text("Upload your first image")
                                .font(.poppins(.light, size: 15))
                            AddImage(showCamera: $showCamera)
                                .frame(maxWidth: 150)
                                .environmentObject(cameraManager)
                        } else {
                            ScrollView {
                                LazyVGrid(columns: columns) {
                                    AddImage(showCamera: $showCamera)
                                        .environmentObject(cameraManager)
                                    ForEach(portfolioViewModel.allPortfolioImages, id: \.id) {image in
                                    
                                        PortfolioImage(image: image)
                                            .contextMenu {
                                                Button(role: .destructive ,action: {
    //
                                                    showAlert = true
                                                }) {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                            .alert("Are you sure you want to delete this image?", isPresented: $showAlert) {
                                      
                                                Button("Delete", role: .destructive) {
                                                    Task {
                                                 
                                                                                                     await portfolioViewModel.deletePostById(photoId: image.id)
                                                                                                     await portfolioViewModel.fetchAllPortfolioImages()
                                                                                                 }
                                                }
                                            }
                                        
                                    }
                             

                            }
                                .padding()
                            }
                           
                       
            
                        }
          
                   
                    }
                   
                    
                    Spacer()
                }
            }
            
           
        }
        .onAppear {
            Task {
                
                await portfolioViewModel.fetchAllPortfolioImages()
            }
        }
    }
}

#Preview {
    let portfolioService = PortfolioService()
    let portfolioViewModel = PortfolioViewModel(portfolioService: portfolioService)
    PortfolioHome()
        .environmentObject(portfolioViewModel)
}


#Preview {
    PressableView()
}

struct PressableView: View {
    @State private var isPressed = false
    
    var body: some View {
        Text("Tap Me")
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}
