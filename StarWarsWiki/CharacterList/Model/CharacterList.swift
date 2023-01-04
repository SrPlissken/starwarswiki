//
//  CharacterList.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import Foundation

struct CharacterList: Codable {
    let next: String
    let previous: String
    let rersults: [Character]
}
