//
//  FilmNS.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 9/1/23.
//


import Foundation

class FilmNS: FilmDataSource {
    let domain = "https://swapi.dev/api/films/"
    
    // Get planet list data for selected page
    func getFilmListData(for page: Int) async throws -> FilmList {
        let sessionUrl = "\(domain)?page=\(page)"
        // Control invalid url
        guard let url = URL(string: sessionUrl) else {
            return FilmList(count: 0, next: "", previous: "", results: [])
        }
        var filmList: FilmList = .init(count: 0, next: "", previous: "", results: [])
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(FilmList.self, from: data) {
                filmList = response
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return filmList
    }
    
    // Get selected planet data
    func getFilmData(for filmUrl: String) async throws -> Film {
        // Control invalid url
        guard let url = URL(string: filmUrl) else {
            return Film.EmptyObject
        }
        var filmData: Film = Film.EmptyObject
        // Go for API call
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(Film.self, from: data) {
                filmData = response
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return filmData
    }
}
