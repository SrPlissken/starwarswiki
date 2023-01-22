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
        let filmData: FilmList
    }
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", filmData: .init(count: 0, next: "", previous: "", results: []))
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadFilmListData() {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let filmNS: FilmNS = .init()
        Task {
            do {
                let filmData = try await filmNS.getFilmListData(for: 1)
                DispatchQueue.main.async {
                    self.loadedViewModel = .init(id: UUID().uuidString, filmData: filmData)
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
