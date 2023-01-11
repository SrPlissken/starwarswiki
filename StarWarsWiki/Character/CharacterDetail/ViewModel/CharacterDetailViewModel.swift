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
    }
    
    private let characterUrl: String
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", characterData: Character.EmptyObject, homeWorld: Planet.EmptyObject, filmList: [])
    
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
                    self.loadedViewModel = .init(id: UUID().uuidString, characterData: characterData, homeWorld: Planet.EmptyObject, filmList: [])
                    self.loadPlanets(homeworld: characterData.homeworld)
                    if characterData.films.count > 0 {
                        self.loadFilms(filmList: characterData.films)
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
}
