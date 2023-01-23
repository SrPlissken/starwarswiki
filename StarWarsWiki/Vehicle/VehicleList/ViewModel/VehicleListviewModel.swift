//
//  VehicleListviewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 23/1/23.
//

import Foundation
import SwiftUI

class VehicleListViewModel: ObservableObject {
    
    // Starship data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: VehicleListViewModel.LoadedViewModel, rhs: VehicleListViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let vehicleData: VehicleList
    }
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", vehicleData: .init(count: 0, next: "", previous: "", results: []))
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadVehicleListData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let vehicleNS: VehicleNS = .init()
        Task {
            do {
                let vehicleData = try await vehicleNS.getVehicleListData(for: 1)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, vehicleData: vehicleData)
                    self.state = .success
                }
            }
            catch {
                self.showErrorAlert = true
                self.state = .failed(ErrorHelper(message: error.localizedDescription))
            }
        }
    }
}
