//
//  CharacterDetailView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 7/1/23.
//

import SwiftUI

struct CharacterDetailView: View {
    
    @ObservedObject var viewModel: CharacterDetailViewModel
    
    var body: some View {
        let state = viewModel.state
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            switch state {
            case .idle:
                Color.clear.onAppear() {
                    viewModel.loadProfileData()
                }
            case .loading:
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading Data")
                }
            case .success:
                ScrollView {
                    VStack(spacing: 10) {
                        AsyncImage(url: URL(string: viewModel.imageURL )) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250)
                        } placeholder: {
                            Image(systemName: "person.2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding()
                        }
                        .cornerRadius(2)
                        
                        // Character name
                        Text(viewModel.loadedViewModel.characterData.name)
                            .font(.title)
                            .padding(.bottom, 30)
                        
                        // Character data
                        VStack {
                            CharacterProperty(propertyName: "Height", propertyValue: viewModel.loadedViewModel.characterData.height)
                            CharacterProperty(propertyName: "Mass", propertyValue: viewModel.loadedViewModel.characterData.mass)
                            CharacterProperty(propertyName: "Hair Color", propertyValue: viewModel.loadedViewModel.characterData.hair_color)
                            CharacterProperty(propertyName: "Skin Color", propertyValue: viewModel.loadedViewModel.characterData.skin_color)
                            CharacterProperty(propertyName: "Eye Color", propertyValue: viewModel.loadedViewModel.characterData.eye_color)
                            CharacterProperty(propertyName: "Birth Year", propertyValue: viewModel.loadedViewModel.characterData.birth_year)
                            CharacterProperty(propertyName: "Gender", propertyValue: viewModel.loadedViewModel.characterData.gender)
                        }
                        .padding(.bottom, 30)
                        
                        // Other character data
                        VStack(spacing: 40) {
                            DetailNavigableCategoryItems(categoryName: "Homeworld", categoryType: "Planets", itemNames: [viewModel.loadedViewModel.homeWorld.name], itemIDCollection: [viewModel.loadedViewModel.homeWorld.imageID ?? ""], viewModel: viewModel)
                            
                            if(viewModel.loadedViewModel.filmList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Films", categoryType: "Films", itemNames: viewModel.loadedViewModel.filmList.map{ $0.title }, itemIDCollection: viewModel.loadedViewModel.filmList.map{ $0.imageID ?? "" }, viewModel: viewModel )
                            }
                            
                            if(viewModel.loadedViewModel.specieList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Species", categoryType: "Species", itemNames: viewModel.loadedViewModel.specieList.map{ $0.name }, itemIDCollection: viewModel.loadedViewModel.specieList.map{ $0.imageID ?? "" }, viewModel: viewModel)
                            }
                            if(viewModel.loadedViewModel.starshipList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Starships", categoryType: "Starships", itemNames: viewModel.loadedViewModel.starshipList.map{ $0.name }, itemIDCollection: viewModel.loadedViewModel.starshipList.map{ $0.imageID ?? "" }, viewModel: viewModel)
                            }
                            if(viewModel.loadedViewModel.vehicleList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Vehicles", categoryType: "Vehicles", itemNames: viewModel.loadedViewModel.vehicleList.map{ $0.name }, itemIDCollection: viewModel.loadedViewModel.vehicleList.map{ $0.imageID ?? "" }, viewModel: viewModel)
                            }
                        }
                        
                        
                        
                    }
                    .navigationBarTitle(Text(viewModel.loadedViewModel.characterData.name), displayMode: .inline)
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

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(viewModel: CharacterDetailViewModel(characterUrl: Character.SampleData.url))
    }
}

// Simple character property view
struct CharacterProperty: View {
    
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
struct DetailNavigableCategoryItems: View {
    
    let categoryName: String
    let categoryType: String
    let itemNames: [String]
    let itemIDCollection: [String]
    let viewModel: CharacterDetailViewModel
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
                        case "Planets":
                            ClickablePlanetItem(destination: AnyView(EmptyView()), itemUrl: viewModel.loadImageForSelectedItem(for: index, category: categoryType), itemName: itemNames[index], itemImage: categoryImages[2])
                                .frame(width: 200)
                        case "Films":
                            ClickableFilmItem(destination: AnyView(EmptyView()), itemUrl: viewModel.loadImageForSelectedItem(for: index, category: categoryType), itemName: itemNames[index], itemImage: categoryImages[3])
                                .frame(width: 180)
                            
                        case "Starships":
                            ClickableStarshipItem(destination: AnyView(EmptyView()), itemUrl: viewModel.loadImageForSelectedItem(for: index, category: categoryType), itemName: itemNames[index], itemImage: categoryImages[1])
                                .frame(width: 180)
                            
                        case "Vehicles":
                            ClickableVehicleItem(destination: AnyView(EmptyView()), itemUrl: viewModel.loadImageForSelectedItem(for: index, category: categoryType), itemName: itemNames[index], itemImage: categoryImages[5])
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
