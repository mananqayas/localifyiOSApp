import SwiftUI



struct MessagesHome: View {
    let chats = MockData.chats
    var body: some View {
        VStack {
            VStack {
                HStack {
              
                    Text("Messages")
                        .font(.poppins(.light, size: 16))
                    
                }
                Rectangle()
                    .fill(Color.localifyBorderColor)
                    .frame(height: 2)
            }
            
            ScrollView {
                ForEach(chats, id:\.id) {chat in
                    
                    NavigationLink(destination: ChatDetailsView(chat: chat)) {
                        ChatRowView(chat: chat)
                      
                    }
                    .padding()
                    Divider()
                       
                    
                }
            }
            
        }
       
    }
}

#Preview {
    NavigationStack {
        MessagesHome()
    }
}
