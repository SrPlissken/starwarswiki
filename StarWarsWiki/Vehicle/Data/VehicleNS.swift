//
//  VehicleNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 12/1/23.
//

import Foundation

class VehicleNS: VehicleDataSource {
    let domain = "https://swapi.dev/api/vehicles/"
    
    // Get vehicle list data for selected page
    func getVehicleListData(for page: Int) async throws -> VehicleList {
        let sessionUrl = "\(domain)?page=\(page)"
        // Control invalid url
        guard let url = URL(string: sessionUrl) else {
            return VehicleList(count: 0, next: "", previous: "", results: [])
        }
        var vehicleList: VehicleList = .init(count: 0, next: "", previous: "", results: [])
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(VehicleList.self, from: data) {
                vehicleList = addImagesID(vehicleList: response)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return vehicleList
    }
    
    // Get selected vehicle data
    func getVehicleData(for starshipUrl: String) async throws -> Vehicle {
        // Control invalid url
        guard let url = URL(string: starshipUrl) else {
            return Vehicle.EmptyObject
        }
        var vehicleData: Vehicle = Vehicle.EmptyObject
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(Vehicle.self, from: data) {
                vehicleData = addProfileImageID(vehicle: response)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return vehicleData
    }
    
    // Add itemId for images
    func addImagesID(vehicleList: VehicleList) -> VehicleList {
        var mutableVehicleList = vehicleList
        for index in mutableVehicleList.results.indices {
            var itemID = mutableVehicleList.results[index].url
            if itemID.hasSuffix("/") {
                itemID.removeLast()
            }
            itemID = itemID.components(separatedBy: "/").last!
            mutableVehicleList.results[index].imageID = itemID
        }
        return mutableVehicleList
    }
    
    // Add itemID for item data
    func addProfileImageID(vehicle: Vehicle) -> Vehicle {
        var mutableVehicleData = vehicle
        var itemID = mutableVehicleData.url
        if itemID.hasSuffix("/") {
            itemID.removeLast()
        }
        itemID = itemID.components(separatedBy: "/").last!
        mutableVehicleData.imageID = itemID
        return mutableVehicleData
    }
}
