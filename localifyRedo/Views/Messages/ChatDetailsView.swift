import SwiftUI

struct ChatDetailsView: View {
    
    let chat: ChatModel
    @Environment(\.dismiss) private var dismiss
    @State private var messageText: String = ""
    let borderColor: Color = Color(red: 176/255, green: 165/255, blue: 165/255)
    
    var otherUser: UserModel {
        
        return chat.user1.id == "currentUser" ? chat.user2: chat.user2
    }
    
    var body: some View {
        
        VStack {
            ScrollViewReader { scrollView in
                
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 18) {
                        ForEach(chat.messages) {message in
                            
                            
                            MessageBubble(message: message, isCurrentUser: message.senderId == "currentUser", chat: chat)
                        }
                    }
                    .padding()
                }
                .onChange(of: chat.messages.count) { oldValue, newValue in
                    withAnimation {
                        scrollView.scrollTo(chat.messages.last?.id, anchor: .bottom)
                    }
                }
                
            }
            Divider()
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor)
                    .frame(height: 40)
                    .overlay {
                        HStack {
                            TextField("Enter your message", text: $messageText)
                                .padding(.horizontal)
                            Image(systemName: "paperplane")
                                .padding(.trailing)
                                .foregroundStyle(.blue)
                                .onTapGesture {
                                    print("sending message")
                                }
                        }
                        
                    }
              
                    
         
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(otherUser.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                }

                
            }
        }
    }
}
