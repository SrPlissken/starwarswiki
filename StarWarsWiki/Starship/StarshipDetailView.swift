//
//  StarshipDetailView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 17/1/23.
//

import SwiftUI

struct StarshipDetailView: View {
    @ObservedObject var viewModel: StarshipDetailViewModel
    
    var body: some View {
        let state = viewModel.state
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            switch state {
            case .idle:
                Color.clear.onAppear(perform: viewModel.loadStarshipData)
            case .loading:
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading Data")
                }
            case .success:
                ScrollView {
                    VStack(spacing: 10) {
                        // Character image
                        Image(systemName: "person.2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding()
                        
                        // Character name
                        Text(viewModel.loadedViewModel.starshipData.name)
                            .font(.title)
                            .padding(.bottom, 30)
                        
                        // Character data
                        VStack {
                            // Avoid swiftui view limitations
                            VStack {
                                StarshipProperty(propertyName: "Model", propertyValue: viewModel.loadedViewModel.starshipData.model)
                                StarshipProperty(propertyName: "Manufacturer", propertyValue: viewModel.loadedViewModel.starshipData.manufacturer)
                                StarshipProperty(propertyName: "Cost In Credits", propertyValue: viewModel.loadedViewModel.starshipData.cost_in_credits)
                                StarshipProperty(propertyName: "Lenght", propertyValue: viewModel.loadedViewModel.starshipData.length)
                                StarshipProperty(propertyName: "Max Atmosphering Speed", propertyValue: viewModel.loadedViewModel.starshipData.max_atmosphering_speed)
                                StarshipProperty(propertyName: "Crew", propertyValue: viewModel.loadedViewModel.starshipData.crew)
                                StarshipProperty(propertyName: "Passengers", propertyValue: viewModel.loadedViewModel.starshipData.passengers)
                            }
                            VStack {
                                StarshipProperty(propertyName: "Cargo Capacity", propertyValue: viewModel.loadedViewModel.starshipData.cargo_capacity)
                                StarshipProperty(propertyName: "Consumables", propertyValue: viewModel.loadedViewModel.starshipData.consumables)
                                StarshipProperty(propertyName: "Hyperdrive Rating", propertyValue: viewModel.loadedViewModel.starshipData.hyperdrive_rating)
                                StarshipProperty(propertyName: "MGLT", propertyValue: viewModel.loadedViewModel.starshipData.MGLT)
                                StarshipProperty(propertyName: "Starship Class", propertyValue: viewModel.loadedViewModel.starshipData.starship_class)
                            }
                        }
                        .padding(.bottom, 30)
                        
                        // Other character data
                        VStack(spacing: 40) {
                            if(viewModel.loadedViewModel.pilotList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Pilots", itemNames: viewModel.loadedViewModel.pilotList.map{ $0.name })
                            }
                            if(viewModel.loadedViewModel.filmList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Films", itemNames: viewModel.loadedViewModel.filmList.map{ $0.title })
                            }
                        }
                    }
                    .navigationBarTitle(Text(viewModel.loadedViewModel.starshipData.name), displayMode: .inline)
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

struct StarshipDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StarshipDetailView(viewModel: StarshipDetailViewModel(starshipUrl: Starship.SampleData.url))
    }
}

// Simple character property view
struct StarshipProperty: View {
    
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
