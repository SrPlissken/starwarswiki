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
        
        ZStack {
            // Background color
            Color.black
                .ignoresSafeArea()
            
            VStack {
                if(searchResults.count > 0) {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            ForEach(searchResults, id: \.self) { item in
                                CharacterItem(destination: RouterHelper.GetViewForDetailSection(category: "Character"), itemName: item.name, itemImage: "person.2")
                            }
                        }
                        .padding(30)
                    }
                }
                else {
                    Text("No results for search")
                        .foregroundColor(.white)
                }
            }
        }
        .navigationBarTitle(Text("Character"), displayMode: .inline)
        .background(.black)
        .foregroundColor(.white)
        .preferredColorScheme(.dark)
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

struct CharacterItem: View {
    
    let destination: AnyView
    let itemName: String
    let itemImage: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 15) {
                Image(systemName: itemImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text(itemName)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, maxHeight: 130)
            .padding(5)
            .foregroundColor(.orange)
            .background(Color.brown)
            .cornerRadius(20)
        }
    }
}
