//
//  Starship.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 12/1/23.
//

import Foundation

struct Starship: Codable, Hashable {
    var name: String
    var model: String
    var manufacturer: String
    var cost_in_credits: String
    var length: String
    var max_atmosphering_speed: String
    var crew: String
    var passengers: String
    var cargo_capacity: String
    var consumables: String
    var hyperdrive_rating: String
    var MGLT: String
    var starship_class: String
    var pilots: [String]
    var films: [String]
    var created: String
    var edited: String
    var url: String
}

extension Starship {
    static let EmptyObject: Starship = .init(name: "", model: "", manufacturer: "", cost_in_credits: "", length: "", max_atmosphering_speed: "", crew: "", passengers: "", cargo_capacity: "", consumables: "", hyperdrive_rating: "", MGLT: "", starship_class: "", pilots: [], films: [], created: "", edited: "", url: "")
    
    static let SampleData: Starship = .init(
        name: "X-wing",
        model: "T-65 X-wing",
        manufacturer: "Incom Corporation",
        cost_in_credits: "149999",
        length: "12.5",
        max_atmosphering_speed: "1050",
        crew: "1",
        passengers: "0",
        cargo_capacity: "110",
        consumables: "1 week",
        hyperdrive_rating: "1.0",
        MGLT: "100",
        starship_class: "Starfighter",
        pilots: [
            "https://swapi.dev/api/people/1/",
            "https://swapi.dev/api/people/9/",
            "https://swapi.dev/api/people/18/",
            "https://swapi.dev/api/people/19/"
          ],
        films: [
            "https://swapi.dev/api/films/1/",
            "https://swapi.dev/api/films/2/",
            "https://swapi.dev/api/films/3/"
          ],
        created: "2014-12-12T11:19:05.340000Z",
        edited: "2014-12-20T21:23:49.886000Z",
        url: "https://swapi.dev/api/starships/12/"
    )
}
