//
//  PlanetDataSource.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 8/1/23.
//

import Foundation

protocol PlanetDataSource {
    func getPlanetListData(for page: Int) async throws -> PlanetList
    func getPlanetData(for characterUrl: String) async throws -> Planet
}
