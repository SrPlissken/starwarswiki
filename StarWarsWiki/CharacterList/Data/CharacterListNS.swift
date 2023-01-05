//
//  CharacterListNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import Foundation
import Combine

class CharacterListNS: CharacterDataSource {
    
    let domain = "https://swapi.dev/api/people/"
    
    // Get character list data for selected page
    func getCharacterData(for page: Int) -> AnyPublisher<CharacterList, Never> {
        // Control invalid url
        let sessionUrl = "\(domain)?page=\(page)"
        guard let url = URL(string: sessionUrl) else {
            return Just<CharacterList>(CharacterList(count: 0, next: "", previous: "", results: [])).eraseToAnyPublisher()
        }
        // Go for API call
        let urlSession: URLSession = .shared
        return urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CharacterList.self, decoder: JSONDecoder())
            .replaceError(with: CharacterList(count: 0, next: "", previous: "", results: []))
            .eraseToAnyPublisher()
    }
}
