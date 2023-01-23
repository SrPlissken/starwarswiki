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
                specieList = response
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
                specieData = response
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return specieData
    }
}
