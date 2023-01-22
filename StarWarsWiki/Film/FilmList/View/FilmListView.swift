//
//  FilmListView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 22/1/23.
//

import SwiftUI

struct FilmListView: View {
    @ObservedObject var viewModel: FilmListViewModel = .init()
    @State var searchText = ""
    
    var searchResults: [Film] {
        viewModel.loadedViewModel.filmData.results.filter { searchText.isEmpty || $0.title.lowercased().contains(searchText.lowercased()) }
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
                Color.clear.onAppear(perform: viewModel.loadFilmListData)
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
                                    ClickableItem(destination: RouterHelper.GetViewForDetailSection(category: "Film", data: item), itemName: item.title, itemImage: "film.stack")
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
        .navigationBarTitle(Text("Film"), displayMode: .inline)
        .background(.black)
        .foregroundColor(.white)
        .preferredColorScheme(.dark)
        .searchable(text: $searchText)    }
}

struct FilmListView_Previews: PreviewProvider {
    static var previews: some View {
        FilmListView()
    }
}
