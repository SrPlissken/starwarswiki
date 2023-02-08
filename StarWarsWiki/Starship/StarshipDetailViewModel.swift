//
//  StarshipDetailViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 17/1/23.
//

import Foundation
import SwiftUI

class StarshipDetailViewModel: ObservableObject {
    
    // Character data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: StarshipDetailViewModel.LoadedViewModel, rhs: StarshipDetailViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let starshipData: Starship
        var pilotList: [Character]
        var filmList: [Film]
    }
    
    private let starshipUrl: String
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", starshipData: Starship.EmptyObject, pilotList: [], filmList: [])
    @Published var imageURL: String = ""
    
    init(starshipUrl: String) {
        self.starshipUrl = starshipUrl
    }
    
    // Load all profile data for selected character
    func loadStarshipData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        let starshipNS: StarshipNS = .init()
        Task {
            do {
                let starshipData = try await starshipNS.getStarshipData(for: starshipUrl)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, starshipData: starshipData, pilotList: [], filmList: [])
                    self.imageURL = self.loadStarshipImage(itemData: starshipData)
                    if starshipData.pilots.count > 0 {
                        self.loadPilots(pilotList: starshipData.pilots)
                    }
                    if starshipData.films.count > 0 {
                        self.loadFilms(filmList: starshipData.films)
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
    // Load films of character data
    func loadPilots(pilotList: [String]) {
        let characterNS: CharacterNS = .init()
        
        for characterUrl in pilotList {
            Task {
                do {
                    let pilotDt = try await characterNS.getCharacterData(for: characterUrl)
                    DispatchQueue.main.async {
                        self.loadedViewModel.pilotList.append(pilotDt)
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
    
    // Load starship image
    func loadStarshipImage(itemData: Starship) -> String{
        let imgDownloader: ImageDownloader = .init()
        if let imageID = itemData.imageID {
            return imgDownloader.getImageForCategoryList(for: "Starships", itemID: imageID)
        }
        return ""
    }
    
    // Load images for selected category and item
    func loadImageForSelectedItem(for index: Int, category: String) -> String{
        let imgDownloader: ImageDownloader = .init()
        var imageID = ""
        switch category {
        case "Characters":
            let selectedItem = loadedViewModel.pilotList[index]
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
