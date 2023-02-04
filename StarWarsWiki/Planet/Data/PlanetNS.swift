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
                planetList = addImagesID(planetList: response)
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
                planetData = addProfileImageID(planet: response)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return planetData
    }
    
    // Add itemId for images
    func addImagesID(planetList: PlanetList) -> PlanetList {
        var mutablePlanetList = planetList
        for index in mutablePlanetList.results.indices {
            var itemID = mutablePlanetList.results[index].url
            if itemID.hasSuffix("/") {
                itemID.removeLast()
            }
            itemID = itemID.components(separatedBy: "/").last!
            mutablePlanetList.results[index].imageID = itemID
        }
        return mutablePlanetList
    }
    
    // Add itemID for item data
    func addProfileImageID(planet: Planet) -> Planet {
        var mutablePlanetData = planet
        var itemID = mutablePlanetData.url
        if itemID.hasSuffix("/") {
            itemID.removeLast()
        }
        itemID = itemID.components(separatedBy: "/").last!
        mutablePlanetData.imageID = itemID
        return mutablePlanetData
    }
}
