//
//  EditSinglePostView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI

struct EditSinglePostView: View {
    
    @Binding var showEditSinglePost: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var showEmptyView: Bool = false
    @State private var title: String = ""
    @State private var description: String = ""
    @EnvironmentObject var postViewModel: PostViewModel
    @State var image: UIImage?
    @State var showCameraMenu: Bool = false
    @State var cameraType: UIImagePickerController.SourceType = .camera
    @State var showCamera: Bool = false
    @FocusState private var titleFocused: Bool
    @FocusState private var contentFocused: Bool
    @State private var oldTitle: String = ""
    @State private var oldContent: String = ""
    @State private var showErrorAlert: Bool = false
    var onUpdate: (()-> Void)?
    
    func updatePost() async{
        let response = await postViewModel.updateASinglePost(postId: postId, title: title, content: description, image: image)
        
        if response {
            onUpdate?()
            dismiss()
        } else {
            showErrorAlert = true
        }
    }

    let postId: String
    var body: some View {
        // header
        VStack {
            HStack {
                Text("Edit your post")
                Spacer()
                Image(systemName: "xmark")
                   
                    .onTapGesture {
                        showEditSinglePost = false
                        print("OK")
                    }
            }
            .alert("Cannot update post", isPresented: $showErrorAlert, actions: {
                Button(role: .cancel) {
                    
                    print("canceled")
                } label: {
                    Text("Cancel")
                }

            })
            .padding(.horizontal)
          
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(Color.localifyBorderColor)
        }
        .zIndex(10)
        ScrollView {
            VStack(spacing: 0) {
                
                
                VStack(alignment: .leading, spacing: 0) {

                    
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.white)
                        .frame(height: 180)
                        .overlay {
                            ZStack(alignment: .topTrailing) {
                                if let imageFromCamera = image {
                                    Image(uiImage: imageFromCamera)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 180)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else {
                                    if let image = postViewModel.singlePost?.imageUrl {
                                        AsyncImage(url: URL(string: image)) {image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                            
                                                .frame(height: 180)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                            
                                            
                                            
                                            
                                        } placeholder: {
                                            Color.gray.opacity(0.1)
                                                .frame(height: 180)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                }
                          
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(height: 180)
                                    .foregroundStyle(LinearGradient(colors: [.red.opacity(0.2), .black.opacity(0.4)], startPoint: .leading, endPoint: .trailing))
                                Image(systemName: "pencil.line")
                                    .foregroundStyle(.white)
                                    .padding()
                                    .onTapGesture {
                                        showCameraMenu = true
                                    }

                            }
                            
                            
                        }
                        .confirmationDialog("Select Camera", isPresented: $showCameraMenu) {
                            Button("Select Camera"){
                                cameraType = .camera
                                showCamera = true
                            }
                            Button("Select Libarary"){
                                cameraType = .photoLibrary
                                showCamera = true
                            }
                        }
                        .sheet(isPresented: $showCamera) {
                            ImagePicker(sourceType: cameraType, selectedImage: $image )
                        }
                        
                    
           
                    // fields
                    VStack(spacing: 20) {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(titleFocused ? .red : Color.localifyBorderColor)
                 
                            .overlay {
                                TextField("", text: $title)
                                    .focused($titleFocused)
                                    .padding(.horizontal)
                               
                            }
                            .frame(height: 50)
                 
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(contentFocused ? .red : Color.localifyBorderColor)
                
                            .overlay {
                                TextEditor(text: $description)
                                    .focused($contentFocused)
                                    .padding()
                            }
                            .frame(height: 300)
                            
                        Button {
                            
                            Task {
                                
                                await updatePost()
                            }

                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.red)
                                .frame(height: 40)
                                .overlay {
                                    Text("Update")
                                        .foregroundStyle(Color.white)
                                        .font(.poppins(.semiBold, size: 14))
                                }
                           
                            
                        }
                        .disabled(oldTitle == title && oldContent == description)
                        
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 30)
                    
                }
                .padding(.top, 20)
                .padding(.horizontal)
                Spacer()
            }
        }
     
        .onAppear {
            Task {
                
                await postViewModel.fetchASinglePost(postId: postId)
                if let post = postViewModel.singlePost {
                    title = post.title
                    description = post.content
                    oldTitle = post.title
                    oldContent = post.content
                }
              
            
            }
        }
        
        
    }
}
 
#Preview {
    let postService = PostService()
    let postViewModel = PostViewModel(postService: postService)
    EditSinglePostView(showEditSinglePost: .constant(false), postId: "684da79060a280df0350c306")
        .environmentObject(postViewModel)
}
