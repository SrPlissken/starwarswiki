//
//  SpeciesDataSource.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 11/1/23.
//

import Foundation

protocol SpecieDataSource {
    func getSpecieListData(for page: Int) async throws -> SpecieList
    func getSpecieData(for specieUrl: String) async throws -> Specie
}
