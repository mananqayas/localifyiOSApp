//
//  SinglePostCardView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI

import SwiftUI

struct SinglePostCardView: View {
    let imageUrl: URL?
    let post: PostModel
    @State var showEditSinglePost: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.localifyBorderColor, lineWidth: 2)
            .overlay {
                HStack(spacing: 20) {
                  
                    AsyncImage(url: imageUrl) {image in
                    image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 140)
                          
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        
                    } placeholder: {
                        Color.gray.opacity(0.2)
                            .frame(width: 150)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(post.title)
                            .font(.poppins(.semiBold, size: 15))
                        Text(formatISODateString(post.createdAt) ?? "")
                            .font(.poppins(.light, size: 12))
                            .foregroundStyle(Color.localifyGray)
                    }
                    Spacer()
                    Image("editBtn")
                        .padding(.trailing, 20)
                 
                }
            }
            .sheet(isPresented: $showEditSinglePost) {
 
            }
            .frame(height: 140)
            .padding()
    }
}

#Preview {
    ScrollView {
        SinglePostCardView(imageUrl: URL(string: "https://picsum.photos/256"), post: PostModel(id: "123", title: "title", content: "content", imageUrl: "", videoUrl: "", createdAt: "2025-06-12T01:17:00.493Z"))
    
        Spacer()
    }
  
}
