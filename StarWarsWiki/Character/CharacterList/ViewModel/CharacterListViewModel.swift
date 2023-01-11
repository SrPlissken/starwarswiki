//
//  CharacterListViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import SwiftUI

class CharacterListViewModel: ObservableObject {
    
    // Character data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: CharacterListViewModel.LoadedViewModel, rhs: CharacterListViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let characterData: CharacterList
    }
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", characterData: .init(count: 0, next: "", previous: "", results: []))
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadCharacterListData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let characterNS: CharacterNS = .init()
        Task {
            do {
                let characterData = try await characterNS.getCharacterListData(for: 1)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, characterData: characterData)
                    self.state = .success
                }
            }
            catch {
                self.showErrorAlert = true
                self.state = .failed(ErrorHelper(message: error.localizedDescription))
            }
        }
    }
}

