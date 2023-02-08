//
//  VehicleDetailviewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 23/1/23.
//

import Foundation
import SwiftUI

class VehicleDetailViewModel: ObservableObject {
    
    // Character data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: VehicleDetailViewModel.LoadedViewModel, rhs: VehicleDetailViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let vehicleData: Vehicle
        var characterList: [Character]
        var filmList: [Film]
    }
    
    private let vehicleUrl: String
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", vehicleData: Vehicle.EmptyObject, characterList: [], filmList: [])
    @Published var imageURL: String = ""
    
    init(vehicleUrl: String) {
        self.vehicleUrl = vehicleUrl
    }
    
    // Load all profile data for selected character
    func loadVehicleData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        let vehicleNS: VehicleNS = .init()
        Task {
            do {
                let vehicleData = try await vehicleNS.getVehicleData(for: vehicleUrl)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, vehicleData: vehicleData, characterList: [], filmList: [])
                    self.imageURL = self.loadVehicleImage(itemData: vehicleData)
                    if vehicleData.pilots.count > 0 {
                        self.loadCharacters(characterList: vehicleData.pilots)
                    }
                    if vehicleData.films.count > 0 {
                        self.loadFilms(filmList: vehicleData.films)
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
    
    // Load characters of vehicle data
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
    
    // Load planets of vehicle data
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
    
    // Load vehicle image
    func loadVehicleImage(itemData: Vehicle) -> String{
        let imgDownloader: ImageDownloader = .init()
        if let imageID = itemData.imageID {
            return imgDownloader.getImageForCategoryList(for: "Vehicles", itemID: imageID)
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
        case "Films":
            let selectedItem = loadedViewModel.filmList[index]
            imageID = selectedItem.imageID ?? ""
        default:
            break
        }
        return imgDownloader.getImageForCategoryList(for: category, itemID: imageID)
    }
}
