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
        var vehicleData: VehicleList
    }
    
    // Save current API data page
    var page : Int = 1
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", vehicleData: .init(count: 0, next: "", previous: "", results: []))
    
    @Published var searchText = ""
    @Published var searchResults: [Vehicle] = []
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadVehicleListData(for page: Int) {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let vehicleNS: VehicleNS = .init()
        Task {
            do {
                let vehicleData = try await vehicleNS.getVehicleListData(for: page)
                DispatchQueue.main.async {
                    // First data load
                    if self.loadedViewModel.vehicleData.results.count == 0 {
                        self.loadedViewModel = .init(id: UUID().uuidString, vehicleData: vehicleData)
                    }
                    // Adding more paginated data
                    else {
                        self.loadedViewModel.vehicleData.count += vehicleData.count
                        self.loadedViewModel.vehicleData.next = vehicleData.next
                        self.loadedViewModel.vehicleData.previous = vehicleData.previous
                        self.loadedViewModel.vehicleData.results += vehicleData.results
                    }
                    self.searchResults = self.loadedViewModel.vehicleData.results
                    self.state = .success
                }
            }
            catch {
                self.showErrorAlert = true
                self.state = .failed(ErrorHelper(message: error.localizedDescription))
            }
        }
    }
    
    // Add more content if needed
    func loadMoreContent(currentIndex index: Int){
        if searchText.isEmpty {
            let thresholdIndex = self.loadedViewModel.vehicleData.results.index(self.loadedViewModel.vehicleData.results.endIndex, offsetBy: -1)
            if thresholdIndex == index, loadedViewModel.vehicleData.next != nil {
                page += 1
                loadVehicleListData(for: page)
            }
        }
    }
}
