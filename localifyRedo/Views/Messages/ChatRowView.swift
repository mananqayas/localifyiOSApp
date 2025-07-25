//
//  MessageModel.swift
//  localify
//
//  Created by Manan Qayas on 03/06/2025.
//

import Foundation
struct UserModel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let profileImage: String
    let isOnline: Bool
}

struct MessageModel: Identifiable, Codable, Hashable {
    let id: String
    let message: String
    let senderId: String
 
    let timestamp: Date
}

struct ChatModel: Identifiable, Codable, Hashable {
    let id: String
    let user1: UserModel
    let user2: UserModel
    let messages: [MessageModel]
    let hasUnreadMessages: Bool
    let unreadCount: Int
    var lastMessage: MessageModel? {
        messages.last
    }
}


struct MockData {
    static let user1 = UserModel(id: "currentUser", name: "You", profileImage: "manan-qayas", isOnline: true)
    static let user2 = UserModel(id: "u2", name: "Jonathan Moya", profileImage: "chatuser", isOnline: true)
    static let user3 = UserModel(id: "u3", name: "John Doe", profileImage: "user22", isOnline: false)
    
    static let messages1 = [
        MessageModel(id: "m1", message: "Hello", senderId: "u2", timestamp: Date()),
        MessageModel(id: "m2", message: "Hello there", senderId: "currentUser", timestamp: Date()),
        MessageModel(id: "m4", message: "Jonathan here", senderId: "u2", timestamp: Date()),
        MessageModel(id: "m5", message: "How are you manan?", senderId: "u2", timestamp: Date()),
    ]
    static let messages2 = [
        MessageModel(id: "m3", message: "Hello 22", senderId: "u3", timestamp: Date()),
        MessageModel(id: "m4", message: "Hello there!!", senderId: "currentUser", timestamp: Date())
        
    ]
    static let chats = [
        ChatModel(id: "c1", user1: user1, user2: user2, messages: messages1, hasUnreadMessages: true, unreadCount: 100),
        ChatModel(id: "c2", user1: user1, user2: user3, messages: messages2, hasUnreadMessages: true, unreadCount: 20)

    ]
    

}


import SwiftUI

struct ChatRowView: View {
    let chat: ChatModel
    
    var otherUser: UserModel {
        
        return chat.user1.id == "currentUser" ? chat.user2 : chat.user1
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Image(otherUser.profileImage)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay (
                    
                    Circle()
                        .foregroundStyle(otherUser.isOnline ? .green : .gray)
                        .frame( width: 10, height: 10)
                        .padding(.bottom, 3)
                        .padding(.trailing, 3)
                        
                   ,
                            alignment: .bottomTrailing
                
                
                )
            
            VStack(alignment: .leading) {
                Text(otherUser.name)
                    .font(.poppins(.semiBold, size: 18))
                    .foregroundStyle(.black)
                if let lastMessage = chat.lastMessage {
                    Text(lastMessage.message)
                        .lineLimit(1)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
            Spacer()
            VStack(spacing: 4) {
                Text("12:00AM")
                    .font(.caption)
                    .foregroundStyle(.gray)
                Circle()
                    .frame(width: 28)
                    .foregroundStyle(.green)
                    .overlay {
                        Text(chat.unreadCount >= 100 ? "99+" : "\(chat.unreadCount)")
                            .font(.system(size: 10))
                            .foregroundStyle(.white)
                    }
                   
            }
        }
    }
}


#Preview {
    ChatRowView(chat: MockData.chats[0])
}
