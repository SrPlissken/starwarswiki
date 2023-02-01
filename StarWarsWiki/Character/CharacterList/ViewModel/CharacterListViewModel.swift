//
//  CharacterListViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 4/1/23.
//

import SwiftUI

class CharacterListViewModel: ObservableObject {
    
    // Character data to display
    struct LoadedViewModel: Equatable {
        static func == (lhs: CharacterListViewModel.LoadedViewModel, rhs: CharacterListViewModel.LoadedViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        let id: String
        var characterData: CharacterList
    }
    
    // Save current API data page
    var page : Int = 1
    
    // Loading state, errors and loaded data access
    @Published private(set) var state: LoadingStateHelper = .idle
    @State var showErrorAlert = false
    @Published var loadedViewModel: LoadedViewModel = .init(id: "", characterData: .init(count: 0, next: "", previous: "", results: []))
    
    @Published var searchText = ""
    @Published var searchResults: [Character] = []
    
    // Constructor
    init() {
    }
    
    // Load character data with loading states and error handling
    func loadCharacterListData(for page: Int) {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        let characterNS: CharacterNS = .init()
        Task {
            do {
                let characterData = try await characterNS.getCharacterListData(for: page)
                DispatchQueue.main.async {
                    // First laod data
                    if self.loadedViewModel.characterData.results.count == 0 {
                        self.loadedViewModel = .init(id: UUID().uuidString, characterData: characterData)
                    }
                    // Adding more paginated data
                    else {
                        self.loadedViewModel.characterData.count += characterData.count
                        self.loadedViewModel.characterData.next = characterData.next
                        self.loadedViewModel.characterData.previous = characterData.previous
                        self.loadedViewModel.characterData.results += characterData.results
                    }
                    self.searchResults = self.loadedViewModel.characterData.results
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
            let thresholdIndex = self.loadedViewModel.characterData.results.index(self.loadedViewModel.characterData.results.endIndex, offsetBy: -1)
            if thresholdIndex == index, loadedViewModel.characterData.next != nil {
                page += 1
                loadCharacterListData(for: page)
            }
        }
    }
    
    // Load images for item list
    func loadImageForSelectedItem(for index: Int) -> String{
        let imgDownloader: ImageDownloader = .init()
        let selectedItem = searchResults[index]
        if let imageID = selectedItem.imageID {
            return imgDownloader.getImageForCategoryList(for: "Characters", itemID: imageID)
        }
        return ""
    }
}

