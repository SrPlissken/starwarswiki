//
//  FilmDetailView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 22/1/23.
//

import SwiftUI

struct FilmDetailView: View {
    @ObservedObject var viewModel: FilmDetailViewModel
    
    var body: some View {
        let state = viewModel.state
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            switch state {
            case .idle:
                Color.clear.onAppear(perform: viewModel.loadFilmData)
            case .loading:
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading Data")
                }
            case .success:
                ScrollView {
                    VStack(spacing: 10) {
                        // Film image
                        Image(systemName: "film.stack")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding()
                        
                        // Film name
                        Text(viewModel.loadedViewModel.filmData.title)
                            .font(.title)
                            .padding(.bottom, 30)
                        
                        // Character data
                        VStack {
                            FilmProperty(propertyName: "Title", propertyValue: viewModel.loadedViewModel.filmData.title)
                            FilmProperty(propertyName: "Episode", propertyValue: viewModel.loadedViewModel.filmData.episode_id.description)
                            FilmProperty(propertyName: "Opening Crawl", propertyValue: viewModel.loadedViewModel.filmData.opening_crawl)
                            FilmProperty(propertyName: "Director", propertyValue: viewModel.loadedViewModel.filmData.director)
                            FilmProperty(propertyName: "Producer", propertyValue: viewModel.loadedViewModel.filmData.producer)
                            FilmProperty(propertyName: "Release Date", propertyValue: viewModel.loadedViewModel.filmData.release_date)
                            
                        }
                        .padding(.bottom, 30)
                        
                        // Other character data
                        VStack(spacing: 40) {
                            if(viewModel.loadedViewModel.characterList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Characters", itemNames: viewModel.loadedViewModel.characterList.map{ $0.name })
                            }
                            if(viewModel.loadedViewModel.planetList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Planets", itemNames: viewModel.loadedViewModel.planetList.map{ $0.name })
                            }
                            if(viewModel.loadedViewModel.starshipList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Starships", itemNames: viewModel.loadedViewModel.starshipList.map{ $0.name })
                            }
                            if(viewModel.loadedViewModel.vehicleList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Vehicles", itemNames: viewModel.loadedViewModel.vehicleList.map{ $0.name })
                            }
                            if(viewModel.loadedViewModel.specieList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Species", itemNames: viewModel.loadedViewModel.specieList.map{ $0.name })
                            }
                        }
                    }
                    .navigationBarTitle(Text(viewModel.loadedViewModel.filmData.title), displayMode: .inline)
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

struct FilmDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FilmDetailView(viewModel: FilmDetailViewModel(filmUrl: Film.SampleData.url))
    }
}

// Simple character property view
struct FilmProperty: View {
    
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
