//
//  EditBusinessDetailsView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI

struct EditBusinessDetailsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
    @State private var isSaving: Bool = false
    @EnvironmentObject var businessViewModel: BusinessViewModel
    @State private var initialIntro: String = ""
 

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .onTapGesture {
                            dismiss()
                        }
                }
                .padding()
                
                Rectangle()
                    .fill(Color.localifyBorderColor)
                    .frame(height: 2)
            }
            VStack(alignment: .leading, spacing: 50) {
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Edit")
                        .font(.poppins(.semiBold, size: 20))
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.localifyBorderColor)
                        
                        TextEditor(text: $text)
                            .focused($isFocused)
                            .padding(.all, 5)
                        
             
                    }
         
                    .frame(height: 150)
                }
              
                
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(initialIntro == text ? .red.opacity(0.2) : .red)
                    .frame(height: 50)
                    .overlay {
                        Text(initialIntro == text && !isSaving ? "Saved" : initialIntro != text && !isSaving ? "Update": "Updating...")
                            .font(.poppins(.semiBold, size: 16))
                            .foregroundStyle(.white)
                    }
                    .onTapGesture {
                        print("saving business")
                        isSaving = true
                        businessViewModel.intro = text
                        dismiss()
                        Task {
                            
                            await businessViewModel.updateBusiness()
                            dismiss()
                            await businessViewModel.getBusinessData()
                            isSaving = false
                        }
                        
                        
                    }
                
                    .onAppear {
                        initialIntro = businessViewModel.intro
                        text = businessViewModel.intro
                     
                    
                    }
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
    EditBusinessDetailsSheet()
        .environmentObject(authViewModel)
        .environmentObject(businessViewModel)
}
