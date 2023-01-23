//
//  Vehicle.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 12/1/23.
//

import Foundation

struct Vehicle: Codable, Hashable {
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
    var vehicle_class: String
    var pilots: [String]
    var films: [String]
    var created: String
    var edited: String
    var url: String
}

extension Vehicle {
    static let EmptyObject: Vehicle = .init(name: "", model: "", manufacturer: "", cost_in_credits: "", length: "", max_atmosphering_speed: "", crew: "", passengers: "", cargo_capacity: "", consumables: "", vehicle_class: "", pilots: [], films: [], created: "", edited: "", url: "")
    
    static let SampleData: Vehicle = .init(
        name: "Snowspeeder",
        model: "t-47 airspeeder",
        manufacturer: "Incom corporation",
        cost_in_credits: "unknown",
        length: "4.5",
        max_atmosphering_speed: "650",
        crew: "2",
        passengers: "0",
        cargo_capacity: "10",
        consumables: "none",
        vehicle_class: "airspeeder",
        pilots: [
            "https://swapi.dev/api/people/1/",
            "https://swapi.dev/api/people/18/"
          ],
        films: [
            "https://swapi.dev/api/films/2/"
          ],
        created: "2014-12-15T12:22:12Z",
        edited: "2014-12-20T21:30:21.672000Z",
        url: "https://swapi.dev/api/vehicles/14/"
    )
}
