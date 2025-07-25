//
//  EditBusinessName.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI
import SwiftUI

struct EditBusinessName: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var businessViewModel: BusinessViewModel
    @State private var isSaving: Bool = false
    @State private var initialName: String = ""
    @State private var businessName: String = ""
    @State private var invalid: Bool = false
    @FocusState private var isFocused: Bool
    
    

    @State private var text: String = ""
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
                VStack(alignment: .leading) {
                    Text("Edit business name")
                        .font(.poppins(.semiBold, size: 20))
                    
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(invalid ? Color.red : isFocused ? Color.blue : Color.localifyBorderColor)
                        .frame(height: 50)
                        .overlay {
                            TextField("", text: $businessName)
                                .padding(.horizontal)
                                .focused($isFocused)
                        }
                    if invalid {
                        Text("Your business name is not changed")
                            .font(.poppins(.light, size: 10))
                            .foregroundStyle(.red)
                    }
  
                }
                
                
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(initialName == businessName ? .red.opacity(0.1)  : .red)
                    .frame(height: 50)
                    .overlay {
                        Text(initialName == businessName && !isSaving  ? "Saved" : initialName != businessName && isSaving ? "Saving..." : "Update")
                            .foregroundStyle(initialName == businessName ? .black : .white)
                            .font(.poppins(.semiBold, size: 15))
                    }
                    .onTapGesture {
                        if initialName == businessName  {
                            invalid = true
                            return
                        }
                        businessViewModel.businessName = businessName
                            invalid = false
                            isSaving = true
                            Task {
                                
                                await businessViewModel.updateBusiness()
                                await businessViewModel.getBusinessData()
                                isSaving = false
                                dismiss()
                                
                            }
                        
                     
                    }
            }
            .padding()
            
//            Text(businessViewModel.businessId ?? "No id")
            Spacer()
        }
        .onAppear {
            initialName = businessViewModel.businessName
            businessName = businessViewModel.businessName
        }
    }
}

#Preview {
    let businessService = BusinessService()
    let businessViewModel = BusinessViewModel(businessService: businessService)
    EditBusinessName()
        .onAppear {
            Task {
                await businessViewModel.getBusinessData()
            }
        }
        .environmentObject(businessViewModel)
}
