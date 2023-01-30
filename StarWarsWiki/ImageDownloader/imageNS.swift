//
//  imageNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 28/1/23.
//

import Foundation
import SwiftUI

class ImageNS {
    let domain = "https://starwars-visualguide.com/assets/img/$category/$id.jpg"
    
    // Switch correct category to see category images
    func getImageForSelectedCategory(for category: String) -> String {
        let trueCat = category.lowercased() == "characters" ? "character" : category.lowercased()
        return domain.replacingOccurrences(of: "$category", with: "categories")
            .replacingOccurrences(of: "$id", with: trueCat)
    }
    
    // TODO: To remove later
    // Aux method to download images
    func getImageForSelectedCategory(for category: String) async throws -> UIImage {
        let fullURL = domain.replacingOccurrences(of: "$category", with: "categories")
            .replacingOccurrences(of: "$id", with: category.lowercased())
        
        var imageResult = UIImage(systemName: category)!
        
        guard let url = URL(string: fullURL) else {
            return imageResult
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = UIImage(data: data) {
                imageResult = response
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        return imageResult
    }
}
