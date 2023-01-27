//
//  CharacterList.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import Foundation

struct CharacterList: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Character]
}
