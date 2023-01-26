//
//  PlanetList.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 8/1/23.
//

import Foundation

struct PlanetList: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Planet]
}
