//
//  FilmListViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 22/1/23.
//

import Foundation
import SwiftUI

class FilmListViewModel: ObservableObject {
    
    // Starship data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: FilmListViewModel.LoadedViewModel, rhs: FilmListViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        var filmData: FilmList
    }
    
    // Save current API data page
    var page : Int = 1
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", filmData: .init(count: 0, next: "", previous: "", results: []))
    
    @Published var searchText = ""
    @Published var searchResults: [Film] = []
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadFilmListData(for page: Int) {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let filmNS: FilmNS = .init()
        Task {
            do {
                let filmData = try await filmNS.getFilmListData(for: page)
                DispatchQueue.main.async {
                    // First data load
                    if self.loadedViewModel.filmData.results.count == 0 {
                        self.loadedViewModel = .init(id: UUID().uuidString, filmData: filmData)
                    }
                    // Adding more paginated data
                    else {
                        self.loadedViewModel.filmData.count += filmData.count
                        self.loadedViewModel.filmData.next = filmData.next
                        self.loadedViewModel.filmData.previous = filmData.previous
                        self.loadedViewModel.filmData.results += filmData.results
                    }
                    self.searchResults = self.loadedViewModel.filmData.results
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
            let thresholdIndex = self.loadedViewModel.filmData.results.index(self.loadedViewModel.filmData.results.endIndex, offsetBy: -1)
            if thresholdIndex == index, loadedViewModel.filmData.next != nil {
                page += 1
                loadFilmListData(for: page)
            }
        }
    }
}
