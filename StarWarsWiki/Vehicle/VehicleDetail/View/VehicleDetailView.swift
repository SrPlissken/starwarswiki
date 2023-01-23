//
//  VehicleDetailView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 23/1/23.
//

import SwiftUI

struct VehicleDetailView: View {
    @ObservedObject var viewModel: VehicleDetailViewModel
    
    var body: some View {
        let state = viewModel.state
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            switch state {
            case .idle:
                Color.clear.onAppear(perform: viewModel.loadVehicleData)
            case .loading:
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading Data")
                }
            case .success:
                ScrollView {
                    VStack(spacing: 10) {
                        // Film image
                        Image(systemName: "airplane")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding()
                        
                        // Film name
                        Text(viewModel.loadedViewModel.vehicleData.name)
                            .font(.title)
                            .padding(.bottom, 30)
                        
                        // Character data
                        VStack {
                            VehicleProperty(propertyName: "Manufacturer", propertyValue: viewModel.loadedViewModel.vehicleData.manufacturer)
                            VehicleProperty(propertyName: "Cost In Credits", propertyValue: viewModel.loadedViewModel.vehicleData.cost_in_credits)
                            VehicleProperty(propertyName: "Lenght", propertyValue: viewModel.loadedViewModel.vehicleData.length)
                            VehicleProperty(propertyName: "Max Atmosphering Speed", propertyValue: viewModel.loadedViewModel.vehicleData.max_atmosphering_speed)
                            VehicleProperty(propertyName: "Crew", propertyValue: viewModel.loadedViewModel.vehicleData.crew)
                            VehicleProperty(propertyName: "Passengers", propertyValue: viewModel.loadedViewModel.vehicleData.passengers)
                            VehicleProperty(propertyName: "Cargo Capacity", propertyValue: viewModel.loadedViewModel.vehicleData.cargo_capacity)
                            VehicleProperty(propertyName: "Consumables", propertyValue: viewModel.loadedViewModel.vehicleData.consumables)
                            VehicleProperty(propertyName: "Vehicle Class", propertyValue: viewModel.loadedViewModel.vehicleData.vehicle_class)
                            
                        }
                        .padding(.bottom, 30)
                        
                        // Other character data
                        VStack(spacing: 40) {
                            if(viewModel.loadedViewModel.characterList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Pilots", itemNames: viewModel.loadedViewModel.characterList.map{ $0.name })
                            }
                            if(viewModel.loadedViewModel.filmList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Films", itemNames: viewModel.loadedViewModel.filmList.map{ $0.title })
                            }
                        }
                    }
                    .navigationBarTitle(Text(viewModel.loadedViewModel.vehicleData.name), displayMode: .inline)
                    .background(.black)
                    .foregroundColor(.white)
                    .preferredColorScheme(.dark)
                    .padding([.leading, .trailing], 20)
                }
                
            case .failed(let errorViewModel):
                Color.clear.alert(isPresented: $viewModel.showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(errorViewModel.message), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}


struct VehicleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleDetailView(viewModel: VehicleDetailViewModel(vehicleUrl: Vehicle.SampleData.url))
    }
}

// Simple character property view
struct VehicleProperty: View {
    
    let propertyName: String
    let propertyValue: String
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(propertyName)
                    .font(.body)
                Spacer()
                Text(propertyValue)
                    .font(.body)
            }
            Rectangle()
                .frame(height: 1)
        }
    }
}
