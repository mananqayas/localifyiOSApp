//
//  AboutBusinessView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import SwiftUI

struct AboutBusinessView: View {
    @State private var intro: String = ""
    @State private var phone: String = ""
    @State private var website: String = ""
    @EnvironmentObject private var navState: NavigationState
    @EnvironmentObject private var businessViewModel: BusinessViewModel
    @State private var showAlert: Bool = false
    var body: some View {
        VStack {
            // header
            NavHeader(title: "Business details")
            
            // headings
            VStack(alignment: .leading) {
                Text("Add your business details")
                    .font(.poppins(.semiBold, size: 28))
                    .padding(.trailing, 60)

            }
            .padding(.horizontal)
            .padding(.top)
            
            VStack(spacing: 20) {
                
                // intro
                TextEditorFieldView(inputText: $businessViewModel.intro)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                //phone
                SingleTextInputView(inputType: .text, text: $businessViewModel.phone, placeholder: "Phone number")
                
                //phone
                SingleTextInputView(inputType: .text, text: $businessViewModel.website, placeholder: "Website")
                
                
                
            }
            .padding(.horizontal, 30)
            .alert(isPresented: $showAlert){
                Alert(
                    title: Text("Some error")
                )
               
            }
            
            Spacer()
            Button("Go to home"){
//
//                showAlert = true
                
                Task {
                    
                    let result = await businessViewModel.createBusiness()
                    
                    if result {
                        navState.path.append(Route.tabView)
                     
                
                    } else {
                        showAlert = true
                    }
                }
            }
            .buttonStyle(CustomButtonStyle())
            .disabled(businessViewModel.intro.isEmpty || businessViewModel.phone.isEmpty || businessViewModel.website.isEmpty)
            .padding()
        }
    }
}

#Preview {
    let businessService = BusinessService()
    let businessViewModel = BusinessViewModel(businessService: businessService)
    AboutBusinessView()
        .environmentObject(businessViewModel)
}
