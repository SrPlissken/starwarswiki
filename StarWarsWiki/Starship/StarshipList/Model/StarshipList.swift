//
//  StarshipList.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 12/1/23.
//

import Foundation

struct StarshipList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Starship]
}
