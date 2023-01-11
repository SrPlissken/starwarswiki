//
//  SpeciesList.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 11/1/23.
//

import Foundation

struct SpecieList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Specie]
}
