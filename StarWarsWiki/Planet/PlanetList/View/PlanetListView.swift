//
//  PlanetListView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 22/1/23.
//

import SwiftUI

struct PlanetListView: View {
    @ObservedObject var viewModel: PlanetListViewModel = .init()
    @State var searchText = ""
    
    var searchResults: [Planet] {
        viewModel.loadedViewModel.planetData.results.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }
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
                Color.clear.onAppear(perform: viewModel.loadPlanetListData)
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
                                    ClickableItem(destination: RouterHelper.GetViewForDetailSection(category: "Planet", data: item), itemName: item.name, itemImage: "globe")
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
        .navigationBarTitle(Text("Planet"), displayMode: .inline)
        .background(.black)
        .foregroundColor(.white)
        .preferredColorScheme(.dark)
        .searchable(text: $searchText)    }
}
struct PlanetListView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetListView()
    }
}
