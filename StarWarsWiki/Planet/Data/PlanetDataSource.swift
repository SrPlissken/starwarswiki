//
//  PlanetDataSource.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 8/1/23.
//

import SwiftUI
import Combine

protocol PlanetDataSource {
    func getPlanetListData(for page: Int) -> AnyPublisher<PlanetList, Never>
    func getPlanetData(for characterUrl: String) -> AnyPublisher<Planet, Never>
}
