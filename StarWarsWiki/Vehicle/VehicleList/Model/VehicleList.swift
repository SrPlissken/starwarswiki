//
//  VehicleList.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 12/1/23.
//

import Foundation

struct VehicleList: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Vehicle]
}
