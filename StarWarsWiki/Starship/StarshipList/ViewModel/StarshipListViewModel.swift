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
        var starshipData: StarshipList
    }
    
    // Save current API data page
    var page : Int = 1
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", starshipData: .init(count: 0, next: "", previous: "", results: []))
    
    @Published var searchText = ""
    @Published var searchResults: [Starship] = []
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadStarshipListData(for page: Int) {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let starshipNS: StarshipNS = .init()
        Task {
            do {
                let starshipData = try await starshipNS.getStarshipListData(for: page)
                DispatchQueue.main.async {
                    // First data load
                    if self.loadedViewModel.starshipData.results.count == 0 {
                        self.loadedViewModel = .init(id: UUID().uuidString, starshipData: starshipData)
                    }
                    // Adding more paginated data
                    else {
                        self.loadedViewModel.starshipData.count += starshipData.count
                        self.loadedViewModel.starshipData.next = starshipData.next
                        self.loadedViewModel.starshipData.previous = starshipData.previous
                        self.loadedViewModel.starshipData.results += starshipData.results
                    }
                    self.searchResults = self.loadedViewModel.starshipData.results
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
            let thresholdIndex = self.loadedViewModel.starshipData.results.index(self.loadedViewModel.starshipData.results.endIndex, offsetBy: -1)
            if thresholdIndex == index, loadedViewModel.starshipData.next != nil {
                page += 1
                loadStarshipListData(for: page)
            }
        }
    }
}
