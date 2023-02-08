//
//  PlanetdetailView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 22/1/23.
//

import SwiftUI

struct PlanetDetailView: View {
    @ObservedObject var viewModel: PlanetDetailViewModel
    
    var body: some View {
        let state = viewModel.state
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            switch state {
            case .idle:
                Color.clear.onAppear(perform: viewModel.loadPlanetData)
            case .loading:
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading Data")
                }
            case .success:
                ScrollView {
                    VStack(spacing: 10) {
                        // Planet image
                        AsyncImage(url: URL(string: viewModel.imageURL )) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250)
                        } placeholder: {
                            Image(systemName: "globe")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding()
                        }
                        .cornerRadius(2)
                        
                        // Character name
                        Text(viewModel.loadedViewModel.planetData.name)
                            .font(.title)
                            .padding(.bottom, 30)
                        
                        // Character data
                        VStack {
                            PlanetProperty(propertyName: "Rotation Period", propertyValue: viewModel.loadedViewModel.planetData.rotation_period)
                            PlanetProperty(propertyName: "Orbital Period", propertyValue: viewModel.loadedViewModel.planetData.orbital_period)
                            PlanetProperty(propertyName: "Diameter", propertyValue: viewModel.loadedViewModel.planetData.diameter)
                            PlanetProperty(propertyName: "Climate", propertyValue: viewModel.loadedViewModel.planetData.climate)
                            PlanetProperty(propertyName: "Gravity", propertyValue: viewModel.loadedViewModel.planetData.gravity)
                            PlanetProperty(propertyName: "Terrain", propertyValue: viewModel.loadedViewModel.planetData.terrain)
                            PlanetProperty(propertyName: "Surface Water", propertyValue: viewModel.loadedViewModel.planetData.surface_water)
                            PlanetProperty(propertyName: "Population", propertyValue: viewModel.loadedViewModel.planetData.population)
                            
                        }
                        .padding(.bottom, 30)
                        
                        // Other character data
                        VStack(spacing: 40) {
                            if(viewModel.loadedViewModel.residentList.count > 0) {
                                DetailNavigableCategoryItemsP(categoryName: "Residents", categoryType: "Characters", itemNames: viewModel.loadedViewModel.residentList.map{ $0.name }, itemIDCollection: viewModel.loadedViewModel.residentList.map{ $0.imageID ?? "" }, viewModel: viewModel)
                            }
                            if(viewModel.loadedViewModel.filmList.count > 0) {
                                DetailNavigableCategoryItemsP(categoryName: "Films", categoryType: "Films", itemNames: viewModel.loadedViewModel.filmList.map{ $0.title }, itemIDCollection: viewModel.loadedViewModel.filmList.map{ $0.imageID ?? "" }, viewModel: viewModel)
                            }
                        }
                    }
                    .navigationBarTitle(Text(viewModel.loadedViewModel.planetData.name), displayMode: .inline)
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

struct PlanetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetDetailView(viewModel: PlanetDetailViewModel(planetUrl: Planet.SampleData.url))
    }
}

// Simple character property view
struct PlanetProperty: View {
    
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
struct DetailNavigableCategoryItemsP: View {
    
    let categoryName: String
    let categoryType: String
    let itemNames: [String]
    let itemIDCollection: [String]
    let viewModel: PlanetDetailViewModel
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
