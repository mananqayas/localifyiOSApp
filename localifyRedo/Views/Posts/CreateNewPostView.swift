//
//  CreateNewPostView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI
struct EmptyPostImage: View {
    @Binding var image: UIImage?

    @State private var showMenu: Bool = false
    @State private var showCameraSheet: Bool = false
    @State private var cameraType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        VStack {
            VStack {
                if let capturedImage = image {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, style: StrokeStyle(dash: [5]))
                        .frame(height: 200)
                        .overlay {
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: capturedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .clipped()
                                Button {
                                    image = nil
                                    print("removing...")
                                } label: {
                                    Image(systemName: "xmark")
                                        .padding()
                                        .foregroundStyle(.white)
                                }

                            }
                                
                                
                        }
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, style: StrokeStyle(dash: [5]))
                        .frame(height: 200)
                        .overlay {
                            HStack {
                                Image("addImage")
                                Text("Add an image")
                                    .foregroundStyle(.red)
                            }
                         
                }
            }
      
        }
            .onTapGesture {
                showMenu = true
            }
        
     
            }
            .confirmationDialog("Select Photo Source", isPresented: $showMenu) {
                Button("Take photo") {
                    cameraType = .camera
                    showCameraSheet = true
                }
                Button("Choose from Library") {
                    cameraType = .photoLibrary
                    showCameraSheet = true
                }
            }
            .sheet(isPresented: $showCameraSheet) {
                ImagePicker(sourceType: cameraType, selectedImage: $image)
            }
    }
    
}
struct CreateNewPostView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var postViewModel: PostViewModel
    @State private var showEmptyView: Bool = true
    @State private var title: String = ""
    @FocusState private var isContentFocused: Bool
    @State private var isSaving: Bool = false
    @State private var content: String  = ""
    @FocusState private var titleFocused: Bool
    @State private var showToast: Bool = false
    @State private var saveText : String = "Save"
    @State private var toastText: String = ""
    @State private var iconName: String = ""
    @EnvironmentObject private var navState: NavigationState
    @State private var image: UIImage?

  
    var onUpdate: (()->Void)?
    
    func savePost() async {
        saveText = "Saving..."
        if let image = image {
           let response = await postViewModel.createASinglePost(title: title, content: content, image: image)
            
            if response {
                onUpdate?()
                dismiss()
            }
        }
        
        }
       
    
    
    func invalid() -> Bool {
        return image == nil || title.isEmpty || content.isEmpty
    }

    var body: some View {
        VStack {
            // header
            ZStack {
                HStack {
                    Spacer()
                    Text("Create a post")
                        .font(.poppins(.semiBold, size: 17))
                    Spacer()
                }
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark")
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    .padding()
                    
                    Rectangle()
                        .fill(Color.localifyBorderColor)
                        .frame(height: 2)
                }
            }
            ZStack(alignment: .top) {
                ScrollView {
          
                    
                    VStack {
              
                        EmptyPostImage(image: $image)
             
                       
                    }
                    .animation(.easeInOut(duration: 0.6), value: showEmptyView)
                    
                    VStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(titleFocused ? .blue : Color.localifyBorderColor)
                            .frame(height: 50)
                            .overlay {
                                TextField("Enter title", text: $title)
                                    .foregroundStyle(Color.localifyGray)
                                    .font(.poppins(.light, size: 15))
                                    .focused($titleFocused)
                                    .padding(.horizontal)
                            }
                            
                     
                        
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(isContentFocused ? .blue : Color.localifyBorderColor)
                            .frame(height: 150)
                            .overlay {
                                ZStack {
                                    if !isContentFocused {
                                        VStack {
                                            HStack {
                                                Text("Enter your post content")
                                                    .foregroundStyle(Color.localifyGray.opacity(0.3))
                                                    .font(.poppins(.light, size: 15))
                                                Spacer()
                                            }
                                            Spacer()
                                        }
                                        .zIndex(2)
                                  
                                    }
                                  
                                    TextEditor(text: $content)
                                        .focused($isContentFocused)
                                }
                                .padding()
                            }
                  
                    }
          
                    
                    }
                    .padding()
                if showToast {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.black)
                        .frame(width: 280 ,height: 60)
                        .overlay {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.green.opacity(0.3))
                                        .frame(height: 40)
                                    Circle()
                                        .fill(Color.green)
                                        .frame(height: 30)
                                        .overlay {
                                            Image(systemName: iconName)
                                        }
                                        
                                }
                                
                                Text(toastText)
                                    .font(.poppins(.medium, size: 17))
                            }
                        }
                        .foregroundStyle(.white)
                        .transition(.opacity)
                }
                
                VStack {
                    Spacer()
                    Button {
                        Task {
                            
                            await  savePost()
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 50)
                            .foregroundStyle(invalid() ? .red.opacity(0.2) : .red)
                            .overlay(content: {
                                Text(saveText)
                                    .font(.poppins(.semiBold, size: 16))
                                    .foregroundStyle(.white)
                            })
                            .padding()
                    }
                    .disabled(invalid())
                }
            }
       
                
               
              
            }
           
  
         
        }
    }


#Preview {
    let postService = PostService()
    let postViewModel = PostViewModel(postService: postService)
    
    CreateNewPostView()
        .environmentObject(postViewModel)
}
