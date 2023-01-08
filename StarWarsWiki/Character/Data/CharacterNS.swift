//
//  CharacterListNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import Foundation
import Combine

class CharacterNS: CharacterDataSource {
    
    let domain = "https://swapi.dev/api/people/"
    
    // Get character list data for selected page
    func getCharacterListData(for page: Int) -> AnyPublisher<CharacterList, Never> {
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
    
    // Get selected character data
    func getCharacterData(for characterUrl: String) -> AnyPublisher<Character, Never> {
        guard let url = URL(string: characterUrl) else {
            return Just<Character>(Character.EmptyObject).eraseToAnyPublisher()
        }
        // Go for API call
        let urlSession: URLSession = .shared
        return urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Character.self, decoder: JSONDecoder())
            .replaceError(with: Character.EmptyObject)
            .eraseToAnyPublisher()
    }
}
