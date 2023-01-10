//
//  FilmDataSource.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 9/1/23.
//

import Foundation

protocol FilmDataSource {
    func getFilmListData(for page: Int) async throws -> FilmList
    func getFilmData(for filmUrl: String) async throws -> Film
}
