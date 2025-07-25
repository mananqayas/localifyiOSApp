//
//  AddBusinessAddressView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import SwiftUI

struct AddBusinessAddressView: View {
    @State private var streetAddress: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""
    @EnvironmentObject  var navState: NavigationState
    @EnvironmentObject  var authViewModel: AuthViewModel
    @EnvironmentObject private var businessViewModel: BusinessViewModel
    var body: some View {
        VStack {
            
            // header
            NavHeader(title: "Business address")
            
            // headings
            VStack(alignment: .leading) {
                Text("Where is your business located?")
                    .font(.poppins(.semiBold, size: 28))
                    .padding(.trailing, 60)
                Text("Enter physical address of your business.")
                    .font(.poppins(.light, size: 15))
                    .foregroundStyle(Color.localifyGray)
                    .padding(.trailing, 70)

            }
            .padding(.horizontal)
            .padding(.top)
            
            
            // text field
            
            VStack(alignment: .leading, spacing: 20) {
                SingleTextInputView(inputType: .text, text: $businessViewModel.street, placeholder: "Street address")
                SingleTextInputView(inputType: .text, text: $businessViewModel.city, placeholder: "City")
                SingleTextInputView(inputType: .text, text: $businessViewModel.state, placeholder: "State")
                SingleTextInputView(inputType: .text, text: $businessViewModel.ZipCode, placeholder: "Zip code")
            }
 
            .padding(.horizontal)
            .padding(.top)
          
            
            Spacer()
            
            // btn
            
            Button("Add business details") {
                authViewModel.isLoggedIn = true
                navState.path.append(Route.aboutBusiness)
                
            }
            .buttonStyle(CustomButtonStyle())
            .padding()
            .disabled(businessViewModel.street.isEmpty || businessViewModel.city.isEmpty || businessViewModel.state.isEmpty || businessViewModel.ZipCode.isEmpty)
        }
    }
}

#Preview {
    let businessService = BusinessService()
    let businessViewModel = BusinessViewModel(businessService: businessService)
    AddBusinessAddressView()
        .environmentObject(businessViewModel)
}
