//
//  StarshipListView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 16/1/23.
//

import SwiftUI

struct StarshipListView: View {
    @ObservedObject var viewModel: StarshipListViewModel = .init()
    @State var searchText = ""
    
    var searchResults: [Starship] {
        viewModel.loadedViewModel.starshipData.results.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }
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
                Color.clear.onAppear(perform: viewModel.loadStarshipListData)
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
                                    ClickableItem(destination: RouterHelper.GetViewForDetailSection(category: "Starship", data: item), itemName: item.name, itemImage: "airplane.departure")
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
        .navigationBarTitle(Text("Starship"), displayMode: .inline)
        .background(.black)
        .foregroundColor(.white)
        .preferredColorScheme(.dark)
        .searchable(text: $searchText)    }
}

struct StarshipListView_Previews: PreviewProvider {
    static var previews: some View {
        StarshipListView()
    }
}
