//
//  CharacterListView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 3/1/23.
//

import SwiftUI

struct CharacterListView: View {
    
    @ObservedObject var viewModel: CharacterListViewModel = .init(networkService: CharacterNS())
    @State var searchText = ""
    
    var searchResults: [Character] {
        viewModel.loadedViewModel.characterData.results.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        let state = viewModel.state
        ZStack {
            // Background color
            Color.black
                .ignoresSafeArea()
            
            // View state load
            switch state {
            case .idle:
                Color.clear.onAppear(perform: viewModel.loadCharacterListData)
            case .loading:
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading Data")
                }
            case .success:
                VStack {
                    if(searchResults.count > 0) {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(), GridItem()]) {
                                ForEach(searchResults, id: \.self) { item in
                                    ClickableItem(destination: RouterHelper.GetViewForDetailSection(category: "Character", character: item), itemName: item.name, itemImage: "person.2")
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
            case .failed(let errorViewModel):
                Color.clear.alert(isPresented: $viewModel.showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(errorViewModel.message), dismissButton: .default(Text("OK")))
                }
            }
        }
        .navigationBarTitle(Text("Character"), displayMode: .inline)
        .background(.black)
        .foregroundColor(.white)
        .preferredColorScheme(.dark)
        .searchable(text: $searchText)    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}

struct ClickableItem: View {
    
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
