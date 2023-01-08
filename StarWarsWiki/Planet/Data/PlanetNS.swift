//
//  PlanetNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 8/1/23.
//

import Foundation
import Combine

class PlanetNS: PlanetDataSource {
    let domain = "https://swapi.dev/api/planets/"
    
    // Get planet list data for selected page
    func getPlanetListData(for page: Int) -> AnyPublisher<PlanetList, Never> {
        // Control invalid url
        let sessionUrl = "\(domain)?page=\(page)"
        guard let url = URL(string: sessionUrl) else {
            return Just<PlanetList>(PlanetList(count: 0, next: "", previous: "", results: [])).eraseToAnyPublisher()
        }
        // Go for API call
        let urlSession: URLSession = .shared
        return urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PlanetList.self, decoder: JSONDecoder())
            .replaceError(with: PlanetList(count: 0, next: "", previous: "", results: []))
            .eraseToAnyPublisher()
    }
    
    // Get selected planet data
    func getPlanetData(for characterUrl: String) -> AnyPublisher<Planet, Never> {
        guard let url = URL(string: characterUrl) else {
            return Just<Planet>(Planet.EmptyObject).eraseToAnyPublisher()
        }
        // Go for API call
        let urlSession: URLSession = .shared
        return urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Planet.self, decoder: JSONDecoder())
            .replaceError(with: Planet.EmptyObject)
            .eraseToAnyPublisher()
    }
}
