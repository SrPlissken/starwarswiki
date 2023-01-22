//
//  Planet.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 8/1/23.
//

import Foundation

struct Planet: Codable, Hashable {
    var name: String
    var rotation_period: String
    var orbital_period: String
    var diameter: String
    var climate: String
    var gravity: String
    var terrain: String
    var surface_water: String
    var population: String
    var residents: [String]
    var films: [String]
    var created: String
    var edited: String
    var url: String
}

extension Planet {
    static let EmptyObject: Planet = .init(
        name: "",
        rotation_period: "",
        orbital_period: "",
        diameter: "",
        climate: "",
        gravity: "",
        terrain: "",
        surface_water: "",
        population: "",
        residents: [],
        films: [],
        created: "",
        edited: "",
        url: ""
    )
    
    static let SampleData: Planet = .init(
        name: "Tatooine",
        rotation_period: "23",
        orbital_period: "304",
        diameter: "10465",
        climate: "arid",
        gravity: "1 standard",
        terrain: "desert",
        surface_water: "1",
        population: "200000",
        residents: [
        "https://swapi.dev/api/people/1/",
        "https://swapi.dev/api/people/2/",
        "https://swapi.dev/api/people/4/",
        "https://swapi.dev/api/people/6/",
        "https://swapi.dev/api/people/7/",
        "https://swapi.dev/api/people/8/",
        "https://swapi.dev/api/people/9/",
        "https://swapi.dev/api/people/11/",
        "https://swapi.dev/api/people/43/",
        "https://swapi.dev/api/people/62/"
      ],
        films: [
            "https://swapi.dev/api/films/1/",
            "https://swapi.dev/api/films/3/",
            "https://swapi.dev/api/films/4/",
            "https://swapi.dev/api/films/5/",
            "https://swapi.dev/api/films/6/"
          ],
        created: "2014-12-09T13:50:49.641000Z",
        edited: "2014-12-20T20:58:18.411000Z",
        url: "https://swapi.dev/api/planets/1/"
    )
}
