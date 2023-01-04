//
//  CharacterDataSource.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import SwiftUI
import Combine

protocol CharacterDataSource {
    func getCharacterData(for page: Int) -> AnyPublisher<CharacterList, Never>
}
