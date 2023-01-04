//
//  CharacterListViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import SwiftUI
import Combine

class CharacterListViewModel: ObservableObject {
    
    private var postsPublisher: AnyCancellable?
    private let networkService: CharacterListNS
    
    init(networkService: CharacterListNS) {
        self.networkService = networkService
    }
    
    func loadCharacterListData() {
        
    }
}

