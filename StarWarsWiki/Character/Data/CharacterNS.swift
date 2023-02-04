//
//  CharacterListNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import Foundation

class CharacterNS: CharacterDataSource {
    let domain = "https://swapi.dev/api/people/"
    
    // Get character list data for selected page
    func getCharacterListData(for page: Int) async throws -> CharacterList {
        // Control invalid url
        let sessionUrl = "\(domain)?page=\(page)"
        guard let url = URL(string: sessionUrl) else {
            return CharacterList(count: 0, next: "", previous: "", results: [])
        }
        var characterList: CharacterList = .init(count: 0, next: "", previous: "", results: [])
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(CharacterList.self, from: data) {
                characterList = addImagesID(characterList: response)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return characterList
    }
    
    // Get selected character data
    func getCharacterData(for characterUrl: String) async throws -> Character {
        // Control invalid url
        guard let url = URL(string: characterUrl) else {
            return Character.EmptyObject
        }
        var characterData: Character = Character.EmptyObject
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(Character.self, from: data) {
                characterData = addProfileImageID(character: response)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return characterData
    }
    
    // Add itemId for images
    func addImagesID(characterList: CharacterList) -> CharacterList {
        var mutableCharacterList = characterList
        for index in mutableCharacterList.results.indices {
            var itemID = mutableCharacterList.results[index].url
            if itemID.hasSuffix("/") {
                itemID.removeLast()
            }
            itemID = itemID.components(separatedBy: "/").last!
            mutableCharacterList.results[index].imageID = itemID
        }
        return mutableCharacterList
    }
    
    // Add itemID for item data
    func addProfileImageID(character: Character) -> Character {
        var mutableCharacterData = character
        var itemID = mutableCharacterData.url
        if itemID.hasSuffix("/") {
            itemID.removeLast()
        }
        itemID = itemID.components(separatedBy: "/").last!
        mutableCharacterData.imageID = itemID
        return mutableCharacterData
    }
}
