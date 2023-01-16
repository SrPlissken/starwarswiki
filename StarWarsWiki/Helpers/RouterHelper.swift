//
//  RouterHelper.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 3/1/23.
//

import SwiftUI

final class RouterHelper {
    
    // Helper to navigate to desired view
    public static func GetViewForSelection(index: Int) -> AnyView {
        switch index {
        case 0:
            return AnyView(CharacterListView())
        case 1:
            return AnyView(StarshipListView())
        default:
            return AnyView(EmptyView())
        }
    }
    
    // Helper to navigate to desired detail item section
    public static func GetViewForDetailSection(category: String, data: Any) -> AnyView {
        switch category {
        case "Character":
            let character: Character = data as! Character
            return AnyView(CharacterDetailView(viewModel: CharacterDetailViewModel(characterUrl: character.url)))
        case "Starship":
            let _: Starship = data as! Starship
            return AnyView(EmptyView())
        default:
            return AnyView(EmptyView())
        }
    }
}
