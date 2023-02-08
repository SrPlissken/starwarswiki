//
//  PlanetDetailViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 22/1/23.
//

import Foundation
import SwiftUI

class PlanetDetailViewModel: ObservableObject {
    
    // Character data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: PlanetDetailViewModel.LoadedViewModel, rhs: PlanetDetailViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let planetData: Planet
        var residentList: [Character]
        var filmList: [Film]
    }
    
    private let planetUrl: String
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", planetData: Planet.EmptyObject, residentList: [], filmList: [])
    @Published var imageURL: String = ""
    
    init(planetUrl: String) {
        self.planetUrl = planetUrl
    }
    
    // Load all profile data for selected character
    func loadPlanetData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        let planetNS: PlanetNS = .init()
        Task {
            do {
                let planetData = try await planetNS.getPlanetData(for: planetUrl)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, planetData: planetData, residentList: [], filmList: [])
                    self.imageURL = self.loadPlanetImage(itemData: planetData)
                    if planetData.residents.count > 0 {
                        self.loadResidents(residentList: planetData.residents)
                    }
                    if planetData.films.count > 0 {
                        self.loadFilms(filmList: planetData.films)
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
    
    // Load Residents of character data
    func loadResidents(residentList: [String]) {
        let characterNS: CharacterNS = .init()
        
        for residentUrl in residentList {
            Task {
                do {
                    let residentDt = try await characterNS.getCharacterData(for: residentUrl)
                    DispatchQueue.main.async {
                        self.loadedViewModel.residentList.append(residentDt)
                    }
                }
                catch {
                    self.showErrorAlert = true
                    self.state = .failed(ErrorHelper(message: error.localizedDescription))
                }
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
    
    // Load planet image
    func loadPlanetImage(itemData: Planet) -> String{
        let imgDownloader: ImageDownloader = .init()
        if let imageID = itemData.imageID {
            return imgDownloader.getImageForCategoryList(for: "Planets", itemID: imageID)
        }
        return ""
    }
    
    // Load images for selected category and item
    func loadImageForSelectedItem(for index: Int, category: String) -> String{
        let imgDownloader: ImageDownloader = .init()
        var imageID = ""
        switch category {
        case "Characters":
            let selectedItem = loadedViewModel.residentList[index]
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
