//
//  CharacterListView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 3/1/23.
//

import SwiftUI

struct CharacterListView: View {
    
    @ObservedObject var viewModel: CharacterListViewModel = .init(networkService: CharacterListNS())
    @State var searchText = ""
    
    var searchResults: [Character] {
        viewModel.characterData.results.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        VStack {
            if(searchResults.count > 0) {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    ForEach(searchResults, id: \.self) { item in
                        Text(item.name)
                    }
                }
            }
            else {
                Text("No results for search")
            }
        }
        .navigationTitle("Characters")
        .searchable(text: $searchText)
        .onAppear() {
            viewModel.loadCharacterListData()
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
