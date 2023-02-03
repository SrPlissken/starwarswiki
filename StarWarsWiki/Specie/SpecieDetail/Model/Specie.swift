//
//  Species.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 11/1/23.
//

import Foundation

struct Specie: Codable, Hashable {
    var name: String
    var classification: String
    var designation: String
    var average_height: String
    var skin_colors: String
    var hair_colors: String
    var eye_colors: String
    var average_lifespan: String
    var homeworld: String?
    var language: String
    var people: [String]
    var films: [String]
    var created: String
    var edited: String
    var url: String
    
    var imageID: String?
}

extension Specie {
    static let EmptyObject: Specie = .init(name: "", classification: "", designation: "", average_height: "", skin_colors: "", hair_colors: "", eye_colors: "", average_lifespan: "", homeworld: "", language: "", people: [], films: [], created: "", edited: "", url: "")
    
    static let SampleData: Specie = .init(
        name: "Human",
        classification: "mammal",
        designation: "sentient",
        average_height: "180",
        skin_colors: "caucasian, black, asian, hispanic",
        hair_colors: "blonde, brown, black, red",
        eye_colors: "brown, blue, green, hazel, grey, amber",
        average_lifespan: "120",
        homeworld: "https://swapi.dev/api/planets/9/",
        language: "Galactic Basic",
        people: [
            "https://swapi.dev/api/people/66/",
            "https://swapi.dev/api/people/67/",
            "https://swapi.dev/api/people/68/",
            "https://swapi.dev/api/people/74/"
          ],
        films: [
            "https://swapi.dev/api/films/1/",
            "https://swapi.dev/api/films/2/",
            "https://swapi.dev/api/films/3/",
            "https://swapi.dev/api/films/4/",
            "https://swapi.dev/api/films/5/",
            "https://swapi.dev/api/films/6/"
          ],
        created: "2014-12-10T13:52:11.567000Z",
        edited: "2014-12-20T21:36:42.136000Z",
        url: "https://swapi.dev/api/species/1/")
}
