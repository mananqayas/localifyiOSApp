//
//  SinglePostDetailView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 11/06/2025.
//

import SwiftUI

struct SinglePostDetailView: View {

    @EnvironmentObject var postViewMode: PostViewModel
    @State private var showAlertForDelete: Bool = false
    @State  var isEditingPost: Bool = false
    @Environment(\.dismiss) var dismiss
 


    var onUpdate: (()-> Void)?
    let postId: String
    
    func deletePost() async {
        let response = await postViewMode.deleteASinglePost(postId: postId)
        if response {
       
            onUpdate?()
        }
    }
    
    var body: some View {
        VStack {
            if isEditingPost {
                EditSinglePostView(showEditSinglePost: $isEditingPost, onUpdate: {
                    Task {
                        
                        await postViewMode.fetchAllPosts()
                    }
                }, postId: postId)
            } else {
                VStack {
                    // Header
                    VStack(spacing: 0) {
                        HStack(spacing: 20) {
                            // edit btn
                            Button {
                                isEditingPost = true
                              
                            } label: {
                                Text("Edit")
                                    .font(.poppins(.regular, size: 15))
                            }
                            // delete btn
                            Button {
                                showAlertForDelete = true
                            } label: {
                                Image(systemName: "trash")
                            }
                            
                            // spacer
                            
                            Spacer()
                            Button {
                                dismiss()
                            
                            } label: {
                                Image(systemName: "xmark")
                            }

                        }
                     
                        .padding()
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.localifyBorderColor)
                    }
                    .zIndex(10)
                    
                    if postViewMode.isLoading {
                        ProgressView()
                    } else {
                        if let post = postViewMode.singlePost {
                            // post content
                            VStack(alignment: .leading, spacing: 30) {
                                // image
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(.gray.opacity(0.2))
                                        .frame(height: 200)
                                    
                                    AsyncImage(url: URL(string: post.imageUrl)) {phase in
                                        switch phase {
                                        case .empty:
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(.gray.opacity(0.2))
                                                .frame(height: 200)
                                                
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 200)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                
                                        case .failure(_):
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(.gray.opacity(0.2))
                                                .frame(height: 200)
                                            
                                        @unknown default:
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(.gray.opacity(0.2))
                                                .frame(height: 200)
                                        }
                                }
                             
                             
                                    
                                }
                                .frame(height: 200)
                                // content
                                VStack(alignment: .leading) {
                                    Text(post.title)
                                        .font(.poppins(.medium, size: 24))
                                    Text(post.content)
                                        .font(.poppins(.light, size: 15))
                                        .foregroundStyle(Color.localifyGray)
                                }
                            }
                            .padding()
                            .alert("Are you sure you want to delete this post?", isPresented: $showAlertForDelete) {
                                Button(role: .cancel) {
                                    
                                } label: {
                                    Text("Cancel")
                                }
                                
                                Button(role: .destructive) {
                                    Task
                                    {
                                        await deletePost()
                                        
                                    }
                                } label: {
                                    Text("Delete")
                                }
                                

                            }
                        }
                  
                    }
                   
                    
                    // Last Spacer
                    Spacer()
                }
            }
        }
        .onAppear {
            Task {
                await postViewMode.fetchASinglePost(postId: postId)
            }
        }
 

    }
        
}

#Preview {

    let postService = PostService()
    let postViewModel = PostViewModel(postService: postService)
    
    SinglePostDetailView(postId: "684cf96a1f695971b246aa37")
        .environmentObject(postViewModel)
}
