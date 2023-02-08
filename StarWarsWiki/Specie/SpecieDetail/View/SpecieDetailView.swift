//
//  SpecieDetailView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 23/1/23.
//

import SwiftUI

struct SpecieDetailView: View {
    @ObservedObject var viewModel: SpecieDetailViewModel
    
    var body: some View {
        let state = viewModel.state
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            switch state {
            case .idle:
                Color.clear.onAppear(perform: viewModel.loadSpecieData)
            case .loading:
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading Data")
                }
            case .success:
                ScrollView {
                    VStack(spacing: 10) {
                        // Specie image
                        AsyncImage(url: URL(string: viewModel.imageURL )) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250)
                        } placeholder: {
                            Image(systemName: "lizzard")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding()
                        }
                        .cornerRadius(2)
                        
                        // Specie name
                        Text(viewModel.loadedViewModel.specieData.name)
                            .font(.title)
                            .padding(.bottom, 30)
                        
                        // Specie data
                        VStack {
                            SpecieProperty(propertyName: "Classification", propertyValue: viewModel.loadedViewModel.specieData.classification)
                            SpecieProperty(propertyName: "Designation", propertyValue: viewModel.loadedViewModel.specieData.designation)
                            SpecieProperty(propertyName: "Average Height", propertyValue: viewModel.loadedViewModel.specieData.average_height)
                            SpecieProperty(propertyName: "Skin Colors", propertyValue: viewModel.loadedViewModel.specieData.skin_colors)
                            SpecieProperty(propertyName: "Hair Colors", propertyValue: viewModel.loadedViewModel.specieData.hair_colors)
                            SpecieProperty(propertyName: "Eye Color", propertyValue: viewModel.loadedViewModel.specieData.eye_colors)
                            SpecieProperty(propertyName: "Average Lifespan", propertyValue: viewModel.loadedViewModel.specieData.average_lifespan)
                            SpecieProperty(propertyName: "Laguage", propertyValue: viewModel.loadedViewModel.specieData.language)
                            
                        }
                        .padding(.bottom, 30)
                        
                        // Other character data
                        VStack(spacing: 40) {
                            if(viewModel.loadedViewModel.characterList.count > 0) {
                                DetailNavigableCategoryItemsS(categoryName: "Characters", categoryType: "Characters", itemNames: viewModel.loadedViewModel.characterList.map{ $0.name }, itemIDCollection: viewModel.loadedViewModel.characterList.map{ $0.imageID ?? "" }, viewModel: viewModel )
                            }
                            if(viewModel.loadedViewModel.filmList.count > 0) {
                                DetailNavigableCategoryItemsS(categoryName: "Films", categoryType: "Films", itemNames: viewModel.loadedViewModel.filmList.map{ $0.title }, itemIDCollection: viewModel.loadedViewModel.filmList.map{ $0.imageID ?? "" }, viewModel: viewModel )
                            }
                        }
                    }
                    .navigationBarTitle(Text(viewModel.loadedViewModel.specieData.name), displayMode: .inline)
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


struct SpecieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SpecieDetailView(viewModel: SpecieDetailViewModel(specieUrl: Specie.SampleData.url))
    }
}

// Simple character property view
struct SpecieProperty: View {
    
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
struct DetailNavigableCategoryItemsS: View {
    
    let categoryName: String
    let categoryType: String
    let itemNames: [String]
    let itemIDCollection: [String]
    let viewModel: SpecieDetailViewModel
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
                            ClickableSpecieItem(destination: AnyView(EmptyView()), itemUrl: viewModel.loadImageForSelectedItem(for: index, category: categoryType), itemName: itemNames[index], itemImage: categoryImages[0])
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
