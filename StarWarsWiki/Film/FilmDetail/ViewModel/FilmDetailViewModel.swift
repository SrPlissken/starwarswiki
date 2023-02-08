//
//  FilmDetailViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 22/1/23.
//

import Foundation
import SwiftUI

class FilmDetailViewModel: ObservableObject {
    
    // Character data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: FilmDetailViewModel.LoadedViewModel, rhs: FilmDetailViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let filmData: Film
        var characterList: [Character]
        var planetList: [Planet]
        var starshipList: [Starship]
        var vehicleList: [Vehicle]
        var specieList: [Specie]
    }
    
    private let filmUrl: String
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", filmData: Film.EmptyObject, characterList: [], planetList: [], starshipList: [], vehicleList: [], specieList: [])
    @Published var imageURL: String = ""
    
    init(filmUrl: String) {
        self.filmUrl = filmUrl
    }
    
    // Load all profile data for selected character
    func loadFilmData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        let filmNS: FilmNS = .init()
        Task {
            do {
                let filmData = try await filmNS.getFilmData(for: filmUrl)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, filmData: filmData, characterList: [], planetList: [], starshipList: [], vehicleList: [], specieList: [])
                    self.imageURL = self.loadFilmImage(itemData: filmData)
                    if filmData.characters.count > 0 {
                        self.loadCharacters(characterList: filmData.characters)
                    }
                    if filmData.planets.count > 0 {
                        self.loadPlanets(planetList: filmData.planets)
                    }
                    if filmData.starships.count > 0 {
                        self.loadStarships(starshipList: filmData.starships)
                    }
                    if filmData.vehicles.count > 0 {
                        self.loadVehicles(vehicleList: filmData.vehicles)
                    }
                    if filmData.species.count > 0 {
                        self.loadSpecies(specieList: filmData.species)
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
    
    // Load characters of film data
    func loadCharacters(characterList: [String]) {
        let characterNS: CharacterNS = .init()
        
        for characterUrl in characterList {
            Task {
                do {
                    let characterDt = try await characterNS.getCharacterData(for: characterUrl)
                    DispatchQueue.main.async {
                        self.loadedViewModel.characterList.append(characterDt)
                    }
                }
                catch {
                    self.showErrorAlert = true
                    self.state = .failed(ErrorHelper(message: error.localizedDescription))
                }
            }
        }
    }
    
    // Load planets of film data
    func loadPlanets(planetList: [String]) {
        let planetNS: PlanetNS = .init()
        
        for planetUrl in planetList {
            Task {
                do {
                    let planetDt = try await planetNS.getPlanetData(for: planetUrl)
                    DispatchQueue.main.async {
                        self.loadedViewModel.planetList.append(planetDt)
                    }
                }
                catch {
                    self.showErrorAlert = true
                    self.state = .failed(ErrorHelper(message: error.localizedDescription))
                }
            }
        }
    }
    
    // Load starships of film data
    func loadStarships(starshipList: [String]) {
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
    
    // Load vehicles of film data
    func loadVehicles(vehicleList: [String]) {
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
    
    // Load species of film data
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
    
    // Load film image
    func loadFilmImage(itemData: Film) -> String{
        let imgDownloader: ImageDownloader = .init()
        if let imageID = itemData.imageID {
            return imgDownloader.getImageForCategoryList(for: "Films", itemID: imageID)
        }
        return ""
    }
    
    // Load images for selected category and item
    func loadImageForSelectedItem(for index: Int, category: String) -> String{
        let imgDownloader: ImageDownloader = .init()
        var imageID = ""
        switch category {
        case "Characters":
            let selectedItem = loadedViewModel.characterList[index]
            imageID = selectedItem.imageID ?? ""
            break
        case "Planets":
            let selectedItem = loadedViewModel.planetList[index]
            imageID = selectedItem.imageID ?? ""
        case "Species":
            let selectedItem = loadedViewModel.specieList[index]
            imageID = selectedItem.imageID ?? ""
        case "Straships":
            let selectedItem = loadedViewModel.starshipList[index]
            imageID = selectedItem.imageID ?? ""
        case "Vehicles":
            let selectedItem = loadedViewModel.vehicleList[index]
            imageID = selectedItem.imageID ?? ""
        default:
            break
        }
        return imgDownloader.getImageForCategoryList(for: category, itemID: imageID)
    }
}
