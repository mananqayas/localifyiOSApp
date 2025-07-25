//
//  TextEditorFieldView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import SwiftUI

struct TextEditorFieldView: View {
    @Binding var inputText: String
    @FocusState var isFocused: Bool
    var body: some View {
        ZStack {
            TextEditor(text: $inputText)
                .focused($isFocused)
                .padding()
                .frame(height: 150)
         
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(lineWidth: 1)
                        .foregroundStyle(isFocused ? Color.localifyAccentBlue : Color.localifyBorderColor)
                        .frame(height: 150)
                        .overlay {
                            if !isFocused && inputText.isEmpty {
                                VStack {
                                    HStack {
                                        Text("Intro of your business")
                                            .font(.poppins(.regular, size: 15))
                                            .foregroundStyle(Color.locaifyFieldPlaceHolderColor)
                                            .padding()
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                         
                          
                            
                        }
                }
        
        }
       
    }
}

#Preview {
    TextEditorFieldView(inputText: .constant(""))
}
