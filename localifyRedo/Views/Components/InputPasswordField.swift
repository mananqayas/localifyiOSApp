//
//  InputPasswordField.swift
//  localifyRedo
//
//  Created by Manan Qayas on 07/06/2025.
//

import SwiftUI

struct InputPasswordField: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    @State private var showPassword: Bool = false

        var body: some View {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(isFocused ? Color.localifyAccentBlue : Color.localifyBorderColor)
          
                .frame(height: 50)
                .overlay {
                    HStack {
                        // textfield
                        if showPassword {
                            TextField("Enter your password", text: $text)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .font(.poppins(.regular, size: 14))
                                .focused($isFocused)
                        } else {
                            SecureField("Enter your password", text: $text)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .font(.poppins(.regular, size: 14))
                                .focused($isFocused)
                        }
                        
                        // xmark icon
                        if !text.isEmpty {
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(showPassword ? "hidePassword" : "showPassword")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                            }
                           
                         

                                
                        }
                     
                    }
                    .padding(.horizontal)
                }
        }
    
}

#Preview {
    InputPasswordField(text: .constant("Manan"))
}
