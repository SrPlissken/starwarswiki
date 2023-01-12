//
//  StartshipNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 12/1/23.
//

import Foundation

class StarshipNS: StarshipDataSource {
    let domain = "https://swapi.dev/api/starships/"
    
    // Get starship list data for selected page
    func getStarshipListData(for page: Int) async throws -> StarshipList {
        let sessionUrl = "\(domain)?page=\(page)"
        // Control invalid url
        guard let url = URL(string: sessionUrl) else {
            return StarshipList(count: 0, next: "", previous: "", results: [])
        }
        var starshipList: StarshipList = .init(count: 0, next: "", previous: "", results: [])
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(StarshipList.self, from: data) {
                starshipList = response
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return starshipList
    }
    
    // Get selected planet data
    func getStarshipData(for starshipUrl: String) async throws -> Starship {
        // Control invalid url
        guard let url = URL(string: starshipUrl) else {
            return Starship.EmptyObject
        }
        var starshipData: Starship = Starship.EmptyObject
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(Starship.self, from: data) {
                starshipData = response
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return starshipData
    }
}
