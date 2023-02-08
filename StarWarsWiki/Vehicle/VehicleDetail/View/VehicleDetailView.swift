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
                        // Vehicle image
                        AsyncImage(url: URL(string: viewModel.imageURL )) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250)
                        } placeholder: {
                            Image(systemName: "airplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding()
                        }
                        .cornerRadius(2)
                        
                        // Vehicle name
                        Text(viewModel.loadedViewModel.vehicleData.name)
                            .font(.title)
                            .padding(.bottom, 30)
                        
                        // Vehicle data
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
                                DetailNavigableCategoryItemsV(categoryName: "Characters", categoryType: "Characters", itemNames: viewModel.loadedViewModel.characterList.map{ $0.name }, itemIDCollection: viewModel.loadedViewModel.characterList.map{ $0.imageID ?? "" }, viewModel: viewModel )
                            }
                            if(viewModel.loadedViewModel.filmList.count > 0) {
                                DetailNavigableCategoryItemsV(categoryName: "Films", categoryType: "Films", itemNames: viewModel.loadedViewModel.filmList.map{ $0.title }, itemIDCollection: viewModel.loadedViewModel.filmList.map{ $0.imageID ?? "" }, viewModel: viewModel )
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

// View with category accesible items
struct DetailNavigableCategoryItemsV: View {
    
    let categoryName: String
    let categoryType: String
    let itemNames: [String]
    let itemIDCollection: [String]
    let viewModel: VehicleDetailViewModel
    let categoryImages = ["person.2", "airplane.departure", "globe", "film.stack", "lizard", "airplane"]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(categoryName)
                    .font(.title)
                Spacer()
            }
            ScrollView(.horizontal) {
                
                HStack(spacing: 20) {
                    ForEach(itemNames.indices, id: \.self) { index in
                        switch categoryType {
                        case "Characters":
                            ClickableCharacterItem(destination: AnyView(EmptyView()), itemUrl: viewModel.loadImageForSelectedItem(for: index, category: categoryType), itemName: itemNames[index], itemImage: categoryImages[0])
                                .frame(width: 160)
                        case "Films":
                            ClickableFilmItem(destination: AnyView(EmptyView()), itemUrl: viewModel.loadImageForSelectedItem(for: index, category: categoryType), itemName: itemNames[index], itemImage: categoryImages[3])
                                .frame(width: 180)
                        default:
                            ClickableItem(destination: AnyView(EmptyView()), itemUrl: "", itemName: itemNames[index], itemImage: categoryImages[2])
                                .frame(width: 200)
                        }
                    }
                }
            }
        }
    }
}
