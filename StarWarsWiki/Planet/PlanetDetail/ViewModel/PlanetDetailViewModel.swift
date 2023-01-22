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
}
