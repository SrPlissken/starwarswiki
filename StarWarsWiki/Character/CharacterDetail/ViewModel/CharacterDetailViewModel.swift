//
//  CharacterDetailViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 7/1/23.
//

import Foundation
import SwiftUI

class CharacterDetailViewModel: ObservableObject {
    
    // Character data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: CharacterDetailViewModel.LoadedViewModel, rhs: CharacterDetailViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let characterData: Character
        var homeWorld: Planet
        var filmList: [Film]
        var specieList: [Specie]
        var starshipList: [Starship]
        var vehicleList: [Vehicle]
    }
    
    private let characterUrl: String
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", characterData: Character.EmptyObject, homeWorld: Planet.EmptyObject, filmList: [], specieList: [], starshipList: [], vehicleList: [])
    @Published var imageURL: String = ""
    
    init(characterUrl: String) {
        self.characterUrl = characterUrl
    }
    
    // Load all profile data for selected character
    func loadProfileData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        let characterNS: CharacterNS = .init()
        Task {
            do {
                let characterData = try await characterNS.getCharacterData(for: characterUrl)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, characterData: characterData, homeWorld: Planet.EmptyObject, filmList: [], specieList: [], starshipList: [], vehicleList: [])
                    self.imageURL = self.loadProfileImage(itemData: characterData)
                    self.loadPlanets(homeworld: characterData.homeworld)
                    if characterData.films.count > 0 {
                        self.loadFilms(filmList: characterData.films)
                    }
                    if characterData.species.count > 0 {
                        self.loadSpecies(specieList: characterData.species)
                    }
                    if characterData.starships.count > 0 {
                        self.loadStarship(starshipList: characterData.starships)
                    }
                    if characterData.vehicles.count > 0 {
                        self.loadVehicle(vehicleList: characterData.vehicles)
                    }
                    self.state = .success
                }
            }
            catch {
                self.showErrorAlert = true
                self.state = .failed(ErrorHelper(message: error.localizedDescription))
            }
        }
    }
    
    // Load homeworld data
    func loadPlanets(homeworld: String) {
        let planetNS: PlanetNS = .init()
        Task {
            do {
                let planetData = try await planetNS.getPlanetData(for: homeworld)
                DispatchQueue.main.async {
                    self.loadedViewModel.homeWorld = planetData
                }
            }
            catch {
                self.showErrorAlert = true
                self.state = .failed(ErrorHelper(message: error.localizedDescription))
            }
        }
    }
    
    // Load films of character data
    func loadFilms(filmList: [String]) {
        let filmNS: FilmNS = .init()
        
        for filmUrl in filmList {
            Task {
                do {
                    let filmDt = try await filmNS.getFilmData(for: filmUrl)
                    DispatchQueue.main.async {
                        self.loadedViewModel.filmList.append(filmDt)
                    }
                }
                catch {
                    self.showErrorAlert = true
                    self.state = .failed(ErrorHelper(message: error.localizedDescription))
                }
            }
        }
    }
    
    // Load specie of character
    func loadSpecies(specieList: [String]) {
        let specieNS: SpecieNS = .init()
        
        for specieUrl in specieList {
            Task {
                do {
                    let specieDt = try await specieNS.getSpecieData(for: specieUrl)
                    DispatchQueue.main.async {
                        self.loadedViewModel.specieList.append(specieDt)
                    }
                }
                catch {
                    self.showErrorAlert = true
                    self.state = .failed(ErrorHelper(message: error.localizedDescription))
                }
            }
        }
    }
    
    // Load starships of character
    func loadStarship(starshipList: [String]) {
        let starshipNS: StarshipNS = .init()
        
        for starshipUrl in starshipList {
            Task {
                do {
                    let starshipDt = try await starshipNS.getStarshipData(for: starshipUrl)
                    DispatchQueue.main.async {
                        self.loadedViewModel.starshipList.append(starshipDt)
                    }
                }
                catch {
                    self.showErrorAlert = true
                    self.state = .failed(ErrorHelper(message: error.localizedDescription))
                }
            }
        }
    }
    
    // Load vehicles of character
    func loadVehicle(vehicleList: [String]) {
        let vehicleNS: VehicleNS = .init()
        
        for vehicleUrl in vehicleList {
            Task {
                do {
                    let vehicleDt = try await vehicleNS.getVehicleData(for: vehicleUrl)
                    DispatchQueue.main.async {
                        self.loadedViewModel.vehicleList.append(vehicleDt)
                    }
                }
                catch {
                    self.showErrorAlert = true
                    self.state = .failed(ErrorHelper(message: error.localizedDescription))
                }
            }
        }
    }
    
    // Load profile imagen
    func loadProfileImage(itemData: Character) -> String{
        let imgDownloader: ImageDownloader = .init()
        if let imageID = itemData.imageID {
            return imgDownloader.getImageForCategoryList(for: "Characters", itemID: imageID)
        }
        return ""
    }
}
