//
//  FilmNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 9/1/23.
//

import Foundation
import Combine

class FilmNS: FilmDataSource {
    let domain = "https://swapi.dev/api/films/"
    
    // Get planet list data for selected page
    func getFilmListData(for page: Int) -> AnyPublisher<FilmList, Never> {
        // Control invalid url
        let sessionUrl = "\(domain)?page=\(page)"
        guard let url = URL(string: sessionUrl) else {
            return Just<FilmList>(FilmList(count: 0, next: "", previous: "", results: [])).eraseToAnyPublisher()
        }
        // Go for API call
        let urlSession: URLSession = .shared
        return urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: FilmList.self, decoder: JSONDecoder())
            .replaceError(with: FilmList(count: 0, next: "", previous: "", results: []))
            .eraseToAnyPublisher()
    }
    
    // Get selected planet data
    func getFilmData(for filmUrl: String) -> AnyPublisher<Film, Never> {
        guard let url = URL(string: filmUrl) else {
            return Just<Film>(Film.EmptyObject).eraseToAnyPublisher()
        }
        // Go for API call
        let urlSession: URLSession = .shared
        return urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Film.self, decoder: JSONDecoder())
            .replaceError(with: Film.EmptyObject)
            .eraseToAnyPublisher()
    }
}
