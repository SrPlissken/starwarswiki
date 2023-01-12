//
//  VehicleDataSource.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 12/1/23.
//

import Foundation

protocol VehicleDataSource {
    func getVehicleListData(for page: Int) async throws -> VehicleList
    func getVehicleData(for vehicleUrl: String) async throws -> Vehicle
}
