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
                filmList = addImagesID(filmList: response)
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
                filmData = addProfileImageID(film: response)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return filmData
    }
    
    // Add itemId for images
    func addImagesID(filmList: FilmList) -> FilmList {
        var mutableFilmList = filmList
        for index in mutableFilmList.results.indices {
            var itemID = mutableFilmList.results[index].url
            if itemID.hasSuffix("/") {
                itemID.removeLast()
            }
            itemID = itemID.components(separatedBy: "/").last!
            mutableFilmList.results[index].imageID = itemID
        }
        return mutableFilmList
    }
    
    // Add itemID for item data
    func addProfileImageID(film: Film) -> Film {
        var mutableFilmData = film
        var itemID = mutableFilmData.url
        if itemID.hasSuffix("/") {
            itemID.removeLast()
        }
        itemID = itemID.components(separatedBy: "/").last!
        mutableFilmData.imageID = itemID
        return mutableFilmData
    }
}
