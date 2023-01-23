//
//  SpeciesListViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 23/1/23.
//

import Foundation
import SwiftUI

class SpecieListViewModel: ObservableObject {
    
    // Starship data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: SpecieListViewModel.LoadedViewModel, rhs: SpecieListViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        let specieData: SpecieList
    }
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", specieData: .init(count: 0, next: "", previous: "", results: []))
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadSpecieListData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let specieNS: SpecieNS = .init()
        Task {
            do {
                let specieData = try await specieNS.getSpecieListData(for: 1)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, specieData: specieData)
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
