//
//  FilmList.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 9/1/23.
//

import Foundation

struct FilmList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Film]
}
