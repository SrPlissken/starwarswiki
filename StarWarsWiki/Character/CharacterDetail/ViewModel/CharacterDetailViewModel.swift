//
//  CharacterDetailViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 7/1/23.
//

import Foundation

class CharacterDetailViewModel: ObservableObject {
    
    @Published var selectedCharacter: Character = Character.EmptyObject
    
    init(selectedCharacter: Character) {
        self.selectedCharacter = selectedCharacter
    }
    
    
}
