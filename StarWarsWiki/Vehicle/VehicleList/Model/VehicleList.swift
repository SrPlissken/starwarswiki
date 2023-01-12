//
//  VehicleList.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 12/1/23.
//

import Foundation

struct VehicleList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Vehicle]
}
