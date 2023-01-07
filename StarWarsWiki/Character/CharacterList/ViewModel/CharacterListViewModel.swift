//
//  CharacterListViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import SwiftUI
import Combine

class CharacterListViewModel: ObservableObject {
    
    // Character data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: CharacterListViewModel.LoadedViewModel, rhs: CharacterListViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let characterData: CharacterList
    }
    
    private var dataPublisher: AnyCancellable?
    private let networkService: CharacterListNS
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", characterData: .init(count: 0, next: "", previous: "", results: []))
    
    // Constructor
    init(networkService: CharacterListNS) {
        self.networkService = networkService
    }
    
    // Load character data with loading states and error handling
    func loadCharacterListData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        dataPublisher = networkService.getCharacterData(for: 1).receive(on: DispatchQueue.main).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.showErrorAlert = true
                self?.state = .failed(ErrorHelper(message: error.localizedDescription))
            }
        } receiveValue: { [weak self] characterList in
            let characterData = characterList
            self?.loadedViewModel = .init(id: UUID().uuidString, characterData: characterData)
            self?.state = .success
        }
    }
}

