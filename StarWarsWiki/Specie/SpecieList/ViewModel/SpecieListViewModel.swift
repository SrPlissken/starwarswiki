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
        var specieData: SpecieList
    }
    
    // Save current API data page
    var page : Int = 1
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", specieData: .init(count: 0, next: "", previous: "", results: []))
    
    @Published var searchText = ""
    @Published var searchResults: [Specie] = []
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadSpecieListData(for page: Int) {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let specieNS: SpecieNS = .init()
        Task {
            do {
                let specieData = try await specieNS.getSpecieListData(for: page)
                DispatchQueue.main.async {
                    // First data load
                    if self.loadedViewModel.specieData.results.count == 0 {
                        self.loadedViewModel = .init(id: UUID().uuidString, specieData: specieData)
                    }
                    // Adding more paginated data
                    else {
                        self.loadedViewModel.specieData.count += specieData.count
                        self.loadedViewModel.specieData.next = specieData.next
                        self.loadedViewModel.specieData.previous = specieData.previous
                        self.loadedViewModel.specieData.results += specieData.results
                    }
                    self.searchResults = self.loadedViewModel.specieData.results
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
            let thresholdIndex = self.loadedViewModel.specieData.results.index(self.loadedViewModel.specieData.results.endIndex, offsetBy: -1)
            if thresholdIndex == index, loadedViewModel.specieData.next != nil {
                page += 1
                loadSpecieListData(for: page)
            }
        }
    }
    
    // Load images for item list
    func loadImageForSelectedItem(for index: Int) -> String{
        let imgDownloader: ImageDownloader = .init()
        let selectedItem = searchResults[index]
        if let imageID = selectedItem.imageID {
            return imgDownloader.getImageForCategoryList(for: "Species", itemID: imageID)
        }
        return ""
    }
}
