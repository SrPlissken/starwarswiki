//
//  FilmList.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 9/1/23.
//

import Foundation

struct FilmList: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Film]
}
