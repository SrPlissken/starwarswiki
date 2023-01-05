//
//  CharacterListViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import SwiftUI
import Combine

class CharacterListViewModel: ObservableObject {
    
    private var dataPublisher: AnyCancellable?
    private let networkService: CharacterListNS
    @Published var characterData: CharacterList = CharacterList(count: 0, next: "", previous: "", results: [])
    
    init(networkService: CharacterListNS) {
        self.networkService = networkService
    }
    
    func loadCharacterListData() {
        dataPublisher = networkService.getCharacterData(for: 1).receive(on: DispatchQueue.main).sink { completion in
            if case .failure(let error) = completion {
                print(error.localizedDescription)
            }
        } receiveValue: { [weak self] characterList in
            
            let characterData = characterList
            self?.characterData = characterData
        }
    }
}

