//
//  SpecieDetailViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 23/1/23.
//

import Foundation
import SwiftUI

class SpecieDetailViewModel: ObservableObject {
    
    // Character data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: SpecieDetailViewModel.LoadedViewModel, rhs: SpecieDetailViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let specieData: Specie
        var characterList: [Character]
        var filmList: [Film]
    }
    
    private let specieUrl: String
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", specieData: Specie.EmptyObject, characterList: [], filmList: [])
    
    init(specieUrl: String) {
        self.specieUrl = specieUrl
    }
    
    // Load all profile data for selected character
    func loadSpecieData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        let specieNS: SpecieNS = .init()
        Task {
            do {
                let specieData = try await specieNS.getSpecieData(for: specieUrl)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, specieData: specieData, characterList: [], filmList: [])
                    if specieData.people.count > 0 {
                        self.loadCharacters(characterList: specieData.people)
                    }
                    if specieData.films.count > 0 {
                        self.loadFilms(filmList: specieData.films)
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
