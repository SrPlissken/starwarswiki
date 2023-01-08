//
//  CharacterDetailViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 7/1/23.
//

import Foundation
import SwiftUI
import Combine

class CharacterDetailViewModel: ObservableObject {
    
    // Character data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: CharacterDetailViewModel.LoadedViewModel, rhs: CharacterDetailViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let characterData: Character
    }
    
    private var dataPublisher: AnyCancellable?
    private let networkService: CharacterNS
    private let characterUrl: String
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", characterData: Character.EmptyObject)
    
    init(characterUrl: String, networkService: CharacterNS) {
        self.characterUrl = characterUrl
        self.networkService = networkService
    }
    
    // Load all profile data for selected character
    func loadProfileData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        dataPublisher = networkService.getCharacterData(for: characterUrl).receive(on: DispatchQueue.main).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.showErrorAlert = true
                self?.state = .failed(ErrorHelper(message: error.localizedDescription))
            }
        } receiveValue: { [weak self] profile in
            let characterData = profile
            self?.loadedViewModel = .init(id: UUID().uuidString, characterData: characterData)
            self?.state = .success
        }
    }
    
}