//
//  SingleTextInputView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 07/06/2025.
//

import SwiftUI

enum InputType {
    case email
    case text
}

struct SingleTextInputView: View {
    let inputType: InputType
    @Binding var text: String
    let placeholder: String
    @FocusState var isFocused: Bool
  

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(isFocused ? Color.localifyAccentBlue : Color.localifyBorderColor)
            .transition(.opacity)
            .frame(height: 50)
            .overlay {
                HStack {
                    // textfield
                    TextField("\(placeholder)", text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .font(.poppins(.regular, size: 14))
                        .focused($isFocused)
                    
                    // xmark icon
                    if !text.isEmpty && inputType == .email {
                        Button {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.prepare()
                            generator.impactOccurred()
                            text = ""
                        } label: {
                            Circle()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color.gray.opacity(0.2))
                                .overlay {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10, height: 10)
                                }
                        }
                        .tint(.localifyGray)
                        .transition(.opacity)

                            
                    }
                 
                }
                .padding(.horizontal)
            }
    }
}

#Preview {
    StatefulPreviewWrapper("") { binding in
        SingleTextInputView(inputType: .text, text: binding, placeholder: "Enter your email")
            .padding()
    }
}

struct StatefulPreviewWrapper<Value>: View {
    @State private var value: Value
    var content: (Binding<Value>) -> AnyView

    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> some View) {
        _value = State(initialValue: initialValue)
        self.content = { AnyView(content($0)) }
    }

    var body: some View {
        content($value)
    }
}
