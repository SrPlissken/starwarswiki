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
        case 2:
            return AnyView(PlanetListView())
        case 3:
            return AnyView(FilmListView())
        case 4:
            return AnyView(SpecieListView())
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
            let starship: Starship = data as! Starship
            return AnyView(StarshipDetailView(viewModel: StarshipDetailViewModel(starshipUrl: starship.url)))
        case "Planet":
            let planet: Planet = data as! Planet
            return AnyView(PlanetDetailView(viewModel: PlanetDetailViewModel(planetUrl: planet.url)))
        case "Film":
            let film: Film = data as! Film
            return AnyView(FilmDetailView(viewModel: FilmDetailViewModel(filmUrl: film.url)))
        case "Specie":
            let specie: Specie = data as! Specie
            return AnyView(SpecieDetailView(viewModel: SpecieDetailViewModel(specieUrl: specie.url)))
        default:
            return AnyView(EmptyView())
        }
    }
}
