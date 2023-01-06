//
//  LoadingStateHelper.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 6/1/23.
//

import Foundation

// Loading API data states
enum LoadingStateHelper: Equatable {
    case idle
    case loading
    case failed(ErrorHelper)
    case success
}
