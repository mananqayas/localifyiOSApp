//
//  EditBusinessServicesSheet.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI

struct EditBusinessServicesSheet: View {
    @Environment(\.dismiss) private var dismiss
    let service: BusinessServiceSingleModel

    @State private var text: String = ""
    @State private var description: String = ""
    @State private var initialText: String = ""
    @State private var initialDescription: String = ""
    @State private var showError: Bool = false
    @FocusState private var focusTitle: Bool
    @FocusState private var focusDes: Bool
    @EnvironmentObject private var businessViewModel: BusinessViewModel
    var onUpdate: (() -> Void)?
    
    
    var body: some View {
        VStack {
            // top
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Text("Edit the service")
                            .font(.poppins(.semiBold, size: 14))
                    }
                    HStack {
                        Spacer()
                        Image(systemName: "xmark")
                            .padding()
                            .onTapGesture {
                                dismiss()
                            }
                    }
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.localifyBorderColor)
            }
            VStack {
           
                RoundedRectangle(cornerRadius: 8)
                    .stroke(focusTitle ? Color.blue : Color.localifyBorderColor)
                    .frame(height: 50)
                    .overlay {
                        TextField("", text: $text)
                            .padding(.horizontal)
                            .focused($focusTitle)
                        
                        
                        
                    }
              
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(focusDes ? Color.blue : Color.localifyBorderColor)
                    .frame(height: 50)
                    .overlay {
                        TextField("", text: $description)
                            .padding(.horizontal)
                            .focused($focusDes)
                        
                        
                    }
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(initialText == text && initialDescription == description ? Color.red.opacity(0.1) : Color.red)
                    .frame(height: 50)
                    .overlay {
                        Text(initialText == text && initialDescription == description ? "Saved" : "Update")
                            .font(.poppins(.medium, size: 15))
                            .foregroundStyle(initialText == text && initialDescription == description ? Color.black : Color.white)
                    }
                    .onTapGesture {
                        if initialText == text && initialDescription == description {
                            return
                        }
                        Task {
                            await businessViewModel.updateBusinessService(name: text, description: description, serviceId: service.id)
                            await businessViewModel.getBusinessData()
                            onUpdate?()
                            dismiss()
                        }
                    }

            
                
                
                
            }
            .task {
                print("running")
                text = service.name
                description = service.description
                initialText = service.name
                initialDescription = service.description
            }
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    let authService = AuthService()
    let authViewModel = AuthViewModel(authService: authService)
    let businessService = BusinessService()
    let businessViewModel = BusinessViewModel(businessService: businessService)
    EditBusinessServicesSheet(service: BusinessServiceSingleModel(id: UUID().uuidString, name: "title", description: "description"))
        .environmentObject(businessViewModel)
        .environmentObject(authViewModel)
}

