//
//  PostsHome.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI

struct PostsHome: View {
    @EnvironmentObject var postViewModel: PostViewModel
    @State private var showCreatePostSheet: Bool = false
    @State private var selectedPost: PostModel? = nil
    @State private var showAlert: Bool = false
  

    var body: some View {
        ZStack {
            VStack {
                // Header
                VStack(spacing: 10) {
                    Text("Posts")
                        .foregroundStyle(Color.localifyGray)
                    Rectangle()
                        .fill(Color.localifyBorderColor)
                        .frame(height: 2)
                }
                
                
                if postViewModel.isLoading {
                    ProgressView()
                    
                } else if postViewModel.allPosts.isEmpty {
                    
                    
                    Image("noPosts")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .padding(.top, 100)
                        
                        VStack {
                            Text("Find all your posts here")
                                .font(.poppins(.semiBold, size: 18))
                            Text("When you will create posts you will see them here")
                                .font(.poppins(.light, size: 13))
                                .foregroundStyle(Color.localifyGray)

                        }
                        .frame(width: 240)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                    Spacer()
                    
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(postViewModel.allPosts)  {post in
                                
                                SinglePostCardView(imageUrl: URL(string: post.imageUrl), post: post)
                                    .contextMenu {
                                     
                                        
                                        Button(action: {
                                            selectedPost = post
                                        }) {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        
                                        Button(role: .destructive, action: {
                                            showAlert = true
                                            
                                        }) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .alert("Are you sure you want to delete this?", isPresented: $showAlert, actions: {
                                        Button("Cancel", role: .cancel){}
                                        Button("Delete", role: .destructive){
                                            Task {
                                                
                                                let _ = await postViewModel.deleteASinglePost(postId: post.id)
                                                await postViewModel.fetchAllPosts()
                                            }
                                        }
                                    }, message: {
                                        Text("This will be deleted permanently")
                                    })
                                    .onTapGesture {
                                        selectedPost = post
                                      
                                    }
                                
                                
                            }
                        }
                        .fullScreenCover(item: $selectedPost) { post in
                            SinglePostDetailView( onUpdate: {
                                Task {
        
                                    await postViewModel.fetchAllPosts()
                                }
                            }, postId: post.id )
                        }
                    }
                }
                // Spacer
                Spacer()
            }
            // bottom button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                
                    Button(action: {
                        showCreatePostSheet.toggle()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "plus")
                                .font(.headline)
                        
                            Text("Create post")
                                .font(.poppins(.medium, size: 14))
                            
                        }
                 

                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(.white)
                                .shadow(color: .localifyGray.opacity(0.1), radius: 10)
                        )
                       
                      
                    }
                    .padding(.bottom, 110)
                    .padding(.trailing, 30)
                  

                   
                }
               
            }
            .ignoresSafeArea()

        }
        .sheet(isPresented: $showCreatePostSheet, content: {
            CreateNewPostView(onUpdate: {
                Task {
                    
                    await postViewModel.fetchAllPosts()
                }
            })
        })
        .onAppear {
            Task {
                
                await postViewModel.fetchAllPosts()
            }
            
        }
       
         
    }
}

#Preview {
    let postService = PostService()
    let postViewModel = PostViewModel(postService: postService)
    
    PostsHome()
        .environmentObject(postViewModel)
}
