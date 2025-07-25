//
//  BusinessServicesView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI
struct AddNewServiceSheet: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private  var businessViewModel: BusinessViewModel
    @FocusState private var emailFocused: Bool
    @FocusState private var descriptionFocused: Bool
    
  
    
    @State private var isNotContent: Bool = false
    var body: some View {
        VStack {
            // top
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Text("Create a service")
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
                
                if isNotContent {
                    Text("Name and description is required")
                        .font(.poppins(.light, size: 15))
                        .foregroundStyle(.red)
                }
            
                RoundedRectangle(cornerRadius: 8)
                    .stroke(emailFocused ? Color.localifyAccentBlue : Color.localifyBorderColor)
                    .frame(height: 50)
                    .overlay {
                        TextField("Cutting grass", text: $name)
                            .padding(.horizontal)
                            .focused($emailFocused)
                    }
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(descriptionFocused ? Color.localifyAccentBlue : Color.localifyBorderColor)
                    .frame(height: 50)
                    .overlay {
                        TextField("We are top rated grass cutters in the neighbourhood", text: $description)
                            .padding(.horizontal)
                            .focused($descriptionFocused)
                    }
                    
                Button("Create service") {
                    if name.isEmpty || description.isEmpty {
                        isNotContent = true
                        return
                        
                    }
                    isNotContent = false
                    Task {
                        
                        do {
                           try await businessViewModel.createAService(name: name, description: description)
                            dismiss()
                            
                            await businessViewModel.getBusinessServices()
                        } catch {
                            print("ERROR")
                        }
                    }
                }
                .buttonStyle(CustomButtonStyle())
                
         
            }
            .padding()
            Spacer()
           

        }
    }
}
struct BusinessServicesView: View {
    @State private var showEditServiceSheet: Bool = false
    @State private var showCreateServiceSheet: Bool = false
    @EnvironmentObject var businessViewModel: BusinessViewModel
    @State private var selectedService: BusinessServiceSingleModel? = nil
    @State private var selectedServiceForEdit: BusinessServiceSingleModel? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Categories and services")
                    .font(.poppins(.semiBold, size: 20))
                
                Spacer()
                Button {
                    showCreateServiceSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                
                
            }
            
            VStack(alignment: .leading) {
                if businessViewModel.isLoadingBusiness {
                    ProgressView()
                } else if businessViewModel.businessServices.isEmpty {
                    VStack {
                        HStack {
                            Spacer()
                            Image("NoServicesFound")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300)
                            Spacer()
                        }
                        Text("No services found")
                            .font(.poppins(.bold, size: 20))
                            .foregroundStyle(Color.localifyGray)
                        Text("Add a new service")
                            .font(.poppins(.light, size: 15))
                            .foregroundStyle(Color.localifyGray)
                    }
                    
                    
                } else {
                    
                    ForEach(businessViewModel.businessServices, id:\.id) { service in
                        VStack(alignment: .leading) {
                            HStack{
                                Text(service.name)
                                    .font(.poppins(.semiBold, size: 16))
                                Spacer()
                                Image(systemName: "pencil")
                                    .onTapGesture {
                                        selectedServiceForEdit = service
                                        
                                    }
                                Image(systemName: "trash")
                                    .onTapGesture {
                                        selectedService = service
                                        
                                    }
                                
                            }
                            ZStack {
                                Text(service.description)
                                    .foregroundStyle(Color(red: 122/255, green: 118/255, blue: 118/255))
                                
                                    .font(.poppins(.light, size: 14))
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.1))
                                        
                                    )
                                
                                
                            }
                            .sheet(item: $selectedServiceForEdit) { service in
                                EditBusinessServicesSheet(service: service,
                                                          onUpdate: {
                                    Task {
                                        
                                        await businessViewModel.getBusinessServices()
                                    }
                                }
                                
                                )
                                    .presentationDetents([.medium])
                                    .presentationDragIndicator(.visible)
                            }

                            
                            
                            
                            
                            
                            
                            
                        }
                        .alert(item: $selectedService) {service in
                            
                            Alert(title: Text("You want to delete \(service.name)?"), message: Text("This will permanently delete the service."), primaryButton: .destructive(Text("Delete")) {
                                print("Deleted \(service.id)")
                                Task {
                                    await businessViewModel.deleteAService(id: service.id)
                                    await businessViewModel.getBusinessServices()
                                }
                            }, secondaryButton: .cancel())
                            
                        }
                        
                    }
                    
                    
                    
                    
                }
                
            }
            .sheet(isPresented: $showCreateServiceSheet) {
                AddNewServiceSheet()
            }
            
        }
        
    }
}

#Preview {
    let businessService = BusinessService()
    let authService = AuthService()
    let authViewModel = AuthViewModel(authService: authService)
    let businessViewModel = BusinessViewModel(businessService: businessService)
    BusinessServicesView()
        .onAppear {
         
            Task {
                
                await businessViewModel.getBusinessData()
                await businessViewModel.getBusinessServices()
            }
        }

        .environmentObject(businessViewModel)
        .environmentObject(authViewModel)
        .padding()
}
