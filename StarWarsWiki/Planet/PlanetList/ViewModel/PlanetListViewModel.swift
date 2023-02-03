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
        var planetData: PlanetList
    }
    
    // Save current API data page
    var page : Int = 1
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @Published var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", planetData: .init(count: 0, next: "", previous: "", results: []))
    
    @Published var searchText = ""
    @Published var searchResults: [Planet] = []
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadPlanetListData(for page: Int) {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let planetNS: PlanetNS = .init()
        Task {
            do {
                let planetData = try await planetNS.getPlanetListData(for: page)
                DispatchQueue.main.async {
                    // First data load
                    if self.loadedViewModel.planetData.results.count == 0 {
                        self.loadedViewModel = .init(id: UUID().uuidString, planetData: planetData)
                    }
                    // Adding more paginated data
                    else {
                        self.loadedViewModel.planetData.count += planetData.count
                        self.loadedViewModel.planetData.next = planetData.next
                        self.loadedViewModel.planetData.previous = planetData.previous
                        self.loadedViewModel.planetData.results += planetData.results
                    }
                    self.searchResults = self.loadedViewModel.planetData.results
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
            let thresholdIndex = self.loadedViewModel.planetData.results.index(self.loadedViewModel.planetData.results.endIndex, offsetBy: -1)
            if thresholdIndex == index, loadedViewModel.planetData.next != nil {
                page += 1
                loadPlanetListData(for: page)
            }
        }
    }
    
    // Load images for item list
    func loadImageForSelectedItem(for index: Int) -> String{
        let imgDownloader: ImageDownloader = .init()
        let selectedItem = searchResults[index]
        if let imageID = selectedItem.imageID {
            return imgDownloader.getImageForCategoryList(for: "Planets", itemID: imageID)
        }
        return ""
    }
}

