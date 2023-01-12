//
//  StarshipDataSource.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 12/1/23.
//

import Foundation

protocol StarshipDataSource {
    func getStarshipListData(for page: Int) async throws -> StarshipList
    func getStarshipData(for starshipUrl: String) async throws -> Starship
}
