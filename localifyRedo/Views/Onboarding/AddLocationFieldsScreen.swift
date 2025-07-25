//
//  AddLocationFieldsScreen.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import SwiftUI

struct AddLocationFieldsScreen: View {
    @State private var businessName: String = ""
    @EnvironmentObject private var navState: NavigationState
    @EnvironmentObject private var businessViewModel: BusinessViewModel
    var body: some View {
        VStack {
            
            // header
            NavHeader(title: "Add your business")
            
            // headings
            VStack(alignment: .leading) {
                Text("Let’s get start with your business name")
                    .font(.poppins(.semiBold, size: 28))
                    .padding(.trailing, 60)
                Text("This will be shown on your business page profile.")
                    .font(.poppins(.light, size: 15))
                    .foregroundStyle(Color.localifyGray)
                    .padding(.trailing, 70)

            }
            .padding(.horizontal)
            .padding(.top)
            
            
            // text field
            
            VStack(alignment: .leading) {
                SingleTextInputView(inputType: .text, text: $businessViewModel.businessName, placeholder: "Business name")
            }
 
            .padding(.horizontal)
            .padding(.top)
          
            
            Spacer()
            
            // btn
            
            Button("Add address") {
                navState.path.append(Route.businessAddress)
            }
            .buttonStyle(CustomButtonStyle())
            .padding()
            .disabled(businessViewModel.businessName.isEmpty || businessViewModel.businessName.count < 10)
        }
    }
}

#Preview {
    let businessService = BusinessService()
    let businessViewModel = BusinessViewModel(businessService: businessService)
    AddLocationFieldsScreen()
        .environmentObject(businessViewModel)
}
