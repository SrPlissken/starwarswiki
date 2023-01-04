//
//  CharacterListView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 3/1/23.
//

import SwiftUI

struct CharacterListView: View {
    
    @ObservedObject var viewModel: CharacterListViewModel = .init()
    @State var searchText = ""
    
    var searchResults: [String] {
        items.filter { searchText.isEmpty || $0.lowercased().contains(searchText.lowercased()) }
    }
    
    let items = ["Item1", "Item2", "Item3", "Item4"]
    var body: some View {
        VStack {
            if(searchResults.count > 0) {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    ForEach(searchResults, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            else {
                Text("No results for search")
            }
        }
        .navigationTitle("Characters")
        .searchable(text: $searchText)
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
