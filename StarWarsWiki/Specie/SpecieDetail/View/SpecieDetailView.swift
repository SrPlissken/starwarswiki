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
                        // Film image
                        Image(systemName: "lizard")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding()
                        
                        // Film name
                        Text(viewModel.loadedViewModel.specieData.name)
                            .font(.title)
                            .padding(.bottom, 30)
                        
                        // Character data
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
                                DetailNavigableCategoryItems(categoryName: "Characters", itemNames: viewModel.loadedViewModel.characterList.map{ $0.name })
                            }
                            if(viewModel.loadedViewModel.filmList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Films", itemNames: viewModel.loadedViewModel.filmList.map{ $0.title })
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
