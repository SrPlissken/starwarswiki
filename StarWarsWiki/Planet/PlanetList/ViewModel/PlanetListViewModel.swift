//
//  PlanetListViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 22/1/23.
//

import Foundation
import SwiftUI

class PlanetListViewModel: ObservableObject {
    
    // Starship data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: PlanetListViewModel.LoadedViewModel, rhs: PlanetListViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let planetData: PlanetList
    }
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", planetData: .init(count: 0, next: "", previous: "", results: []))
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadPlanetListData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let planetNS: PlanetNS = .init()
        Task {
            do {
                let planetData = try await planetNS.getPlanetListData(for: 1)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, planetData: planetData)
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

