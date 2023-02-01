//
//  imageNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 28/1/23.
//

import Foundation
import SwiftUI

class ImageDownloader {
    let domain = "https://starwars-visualguide.com/assets/img/$category/$id.jpg"
    
    // Switch correct category to see category images
    func getImageForSelectedCategory(for category: String) -> String {
        let trueCat = category.lowercased() == "characters" ? "character" : category.lowercased()
        return domain.replacingOccurrences(of: "$category", with: "categories")
            .replacingOccurrences(of: "$id", with: trueCat)
    }
    
    // Get image for category with item id
    func getImageForCategoryList(for category: String, itemID: String) -> String {
        return domain.replacingOccurrences(of: "$category", with: category.lowercased())
            .replacingOccurrences(of: "$id", with: itemID)
    }
}
