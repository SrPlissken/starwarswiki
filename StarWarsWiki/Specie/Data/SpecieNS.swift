//
//  SpecieNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 11/1/23.
//

import Foundation

class SpecieNS: SpecieDataSource {
    let domain = "https://swapi.dev/api/species/"
    
    // Get planet list data for selected page
    func getSpecieListData(for page: Int) async throws -> SpecieList {
        let sessionUrl = "\(domain)?page=\(page)"
        // Control invalid url
        guard let url = URL(string: sessionUrl) else {
            return SpecieList(count: 0, next: "", previous: "", results: [])
        }
        var specieList: SpecieList = .init(count: 0, next: "", previous: "", results: [])
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(SpecieList.self, from: data) {
                specieList = addImagesID(specieList: response)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return specieList
    }
    
    // Get selected planet data
    func getSpecieData(for specieUrl: String) async throws -> Specie {
        // Control invalid url
        guard let url = URL(string: specieUrl) else {
            return Specie.EmptyObject
        }
        var specieData: Specie = Specie.EmptyObject
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(Specie.self, from: data) {
                specieData = addProfileImageID(specie: response)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return specieData
    }
    
    // Add itemId for images
    func addImagesID(specieList: SpecieList) -> SpecieList {
        var mutableSpecieList = specieList
        for index in mutableSpecieList.results.indices {
            var itemID = mutableSpecieList.results[index].url
            if itemID.hasSuffix("/") {
                itemID.removeLast()
            }
            itemID = itemID.components(separatedBy: "/").last!
            mutableSpecieList.results[index].imageID = itemID
        }
        return mutableSpecieList
    }
    
    // Add itemID for item data
    func addProfileImageID(specie: Specie) -> Specie {
        var mutableSpecieData = specie
        var itemID = mutableSpecieData.url
        if itemID.hasSuffix("/") {
            itemID.removeLast()
        }
        itemID = itemID.components(separatedBy: "/").last!
        mutableSpecieData.imageID = itemID
        return mutableSpecieData
    }
}
