//
//  SpeciesList.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 11/1/23.
//

import Foundation

struct SpecieList: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Specie]
}
