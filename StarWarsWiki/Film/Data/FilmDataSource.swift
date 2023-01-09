//
//  FilmDataSource.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 9/1/23.
//

import Foundation
import Combine

protocol FilmDataSource {
    func getFilmListData(for page: Int) -> AnyPublisher<FilmList, Never>
    func getFilmData(for filmUrl: String) -> AnyPublisher<Film, Never>
}
