//
//  CharacterDataSource.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import SwiftUI

protocol CharacterDataSource {
    func getCharacterListData(for page: Int) async throws -> CharacterList
    func getCharacterData(for characterUrl: String) async throws -> Character
}
