//
//  AboutBusinessView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI

struct HomeAboutBusinessView: View {
    @State private var showEditBusinessDetailsSheet: Bool = false
    @EnvironmentObject var businessViewModel: BusinessViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("About \(businessViewModel.businessName)")
               
                    .font(.poppins(.semiBold, size: 20))
                Spacer()
                Image("editpencil")
                    .onTapGesture {
                        showEditBusinessDetailsSheet.toggle()
                    }
                
            }
            Text("\(businessViewModel.intro)")
                .foregroundStyle(Color(red: 122/255, green: 118/255, blue: 118/255))
                .font(.poppins(.light, size: 14))
        }
        .sheet(isPresented: $showEditBusinessDetailsSheet) {
            EditBusinessDetailsSheet()
        }
    }
}

#Preview {
    let businessService = BusinessService()
    let businessViewModel = BusinessViewModel(businessService: businessService)
    
         HomeAboutBusinessView()
        .onAppear {
            Task {
                await businessViewModel.getBusinessData()
            }
        }
        .environmentObject(businessViewModel)
        .padding()
}
