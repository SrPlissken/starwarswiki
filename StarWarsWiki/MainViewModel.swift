//
//  MainViewModel.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 30/1/23.
//

import Foundation

class MainViewModel: ObservableObject {
    
    let categoryPlaceHolders = ["person.2", "airplane.departure", "globe", "film.stack", "lizard", "airplane"]
    let categoryTitle = ["Characters", "Starships", "Planets", "Films", "Species", "Vehicles"]
    @Published var categoryUrls: [String] = []
    
    // Constructor
    init() {
        var categoryUrls: [String] = []
        let imageNS: ImageDownloader = .init()
        for category in categoryTitle {
            categoryUrls.append(imageNS.getImageForSelectedCategory(for: category))
        }
        self.categoryUrls = categoryUrls
    }
    
}
