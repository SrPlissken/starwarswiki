//
//  StarshipListViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 16/1/23.
//

import Foundation
import SwiftUI

class StarshipListViewModel: ObservableObject {
    
    // Starship data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: StarshipListViewModel.LoadedViewModel, rhs: StarshipListViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let starshipData: StarshipList
    }
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", starshipData: .init(count: 0, next: "", previous: "", results: []))
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadStarshipListData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let starshipNS: StarshipNS = .init()
        Task {
            do {
                let starshipData = try await starshipNS.getStarshipListData(for: 1)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, starshipData: starshipData)
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
