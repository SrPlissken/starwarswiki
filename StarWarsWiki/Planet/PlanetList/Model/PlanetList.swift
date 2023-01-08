//
//  PlanetList.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 8/1/23.
//

import Foundation

struct PlanetList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Planet]
}
