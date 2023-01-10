//
//  PlanetNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 8/1/23.
//

import Foundation

class PlanetNS: PlanetDataSource {
    let domain = "https://swapi.dev/api/planets/"
    
    // Get planet list data for selected page
    func getPlanetListData(for page: Int) async throws -> PlanetList {
        let sessionUrl = "\(domain)?page=\(page)"
        // Control invalid url
        guard let url = URL(string: sessionUrl) else {
            return PlanetList(count: 0, next: "", previous: "", results: [])
        }
        var planetList: PlanetList = .init(count: 0, next: "", previous: "", results: [])
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(PlanetList.self, from: data) {
                planetList = response
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return planetList
    }
    
    // Get selected planet data
    func getPlanetData(for filmUrl: String) async throws -> Planet {
        // Control invalid url
        guard let url = URL(string: filmUrl) else {
            return Planet.EmptyObject
        }
        var planetData: Planet = Planet.EmptyObject
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(Planet.self, from: data) {
                planetData = response
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return planetData
    }
}
