//
//  MessageBubble.swift
//  localify
//
//  Created by Manan Qayas on 03/06/2025.
//

import SwiftUI

struct MessageBubble: View {
    let message: MessageModel
    static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()
    
    var isCurrentUser: Bool
    var currentUser: UserModel {
        return chat.user1.id == "currentUser" ? chat.user1 :  chat.user2
    }
    
    var otherUser: UserModel {
        return chat.user1.id == "currentUser" ? chat.user2 :  chat.user2
    }
    let chat: ChatModel
    var body: some View {
        HStack {
            HStack {
                Image(message.senderId == "currentUser" ? currentUser.profileImage :  otherUser.profileImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 50)
                VStack(alignment: .leading) {
                    HStack {
                        Text(isCurrentUser ? "Me": otherUser.name)
                            .font(.poppins(.semiBold, size: 19))
                        
                        Text(Self.formatter.string(from: message.timestamp))
                            .font(.poppins(.light, size: 15))
                            .foregroundStyle(.black)
                    }
                    Text(message.message)
                        .font(.poppins(.regular, size: 15))
                }
                Spacer()
            }
            
        
        }
        .id(message.id)
    }
}
