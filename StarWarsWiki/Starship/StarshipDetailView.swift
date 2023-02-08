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
                        // Starship image
                        AsyncImage(url: URL(string: viewModel.imageURL )) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250)
                        } placeholder: {
                            Image(systemName: "airplane.departure")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding()
                        }
                        .cornerRadius(2)
                        
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
                                DetailNavigableCategoryItemsSS(categoryName: "Pilots", categoryType: "Characters", itemNames: viewModel.loadedViewModel.pilotList.map{ $0.name }, itemIDCollection: viewModel.loadedViewModel.pilotList.map{ $0.imageID ?? "" }, viewModel: viewModel )
                            }
                            if(viewModel.loadedViewModel.filmList.count > 0) {
                                DetailNavigableCategoryItemsSS(categoryName: "Films", categoryType: "Films", itemNames: viewModel.loadedViewModel.filmList.map{ $0.title }, itemIDCollection: viewModel.loadedViewModel.filmList.map{ $0.imageID ?? "" }, viewModel: viewModel )
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

// View with category accesible items
struct DetailNavigableCategoryItemsSS: View {
    
    let categoryName: String
    let categoryType: String
    let itemNames: [String]
    let itemIDCollection: [String]
    let viewModel: StarshipDetailViewModel
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
