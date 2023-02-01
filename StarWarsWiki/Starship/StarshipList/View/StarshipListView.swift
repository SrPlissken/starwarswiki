//
//  StarshipListView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 16/1/23.
//

import SwiftUI

struct StarshipListView: View {
    
    @ObservedObject var viewModel: StarshipListViewModel = .init()
    @State var position: Int = 0
    
    var body: some View {
        let state = viewModel.state
        ZStack {
            // Background color
            Color.black
                .ignoresSafeArea()
            
            // View state load
            switch state {
            case .idle:
                Color.clear.onAppear() {
                    viewModel.loadStarshipListData(for: 1)
                }
            case .loading:
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading Data")
                }
            case .success:
                VStack {
                    if(viewModel.searchResults.count > 0) {
                        ScrollViewReader { sv in
                            ScrollView {
                                LazyVGrid(columns: [GridItem(), GridItem()]) {
                                    ForEach(viewModel.searchResults.indices, id: \.self) { index in
                                        ClickableItem(destination: RouterHelper.GetViewForDetailSection(category: "Starship", data: viewModel.searchResults[index]), itemUrl: "", itemName: viewModel.searchResults[index].name, itemImage: "airplane.departure")
                                        // Checks if we need to update collection with new elements
                                        .onAppear() {
                                            viewModel.loadMoreContent(currentIndex: index)
                                        }
                                    }
                                }
                                .padding(30)
                                // Calculate user position on scroll to recover it when collection changes
                                .background(GeometryReader { proxy -> Color in
                                    if viewModel.searchText.isEmpty {
                                        let offset = -proxy.frame(in: .named("scroll")).origin.y
                                        let itemHeight = proxy.size.height / CGFloat(self.viewModel.searchResults.count)
                                        let currentIndex = Int((offset / itemHeight).rounded())
                                        DispatchQueue.main.async {
                                            self.position = currentIndex
                                        }
                                    }
                                    return Color.clear
                                })
                            }
                            .coordinateSpace(name: "scroll")
                            // Look for changes in results collection and set previous saved position
                            .onReceive(viewModel.$searchResults) { _ in
                                if viewModel.searchText.isEmpty {
                                    sv.scrollTo(self.position)
                                }
                            }
                        }
                    }
                    else {
                        Text("No results for search")
                            .foregroundColor(.white)
                    }
                }
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.searchResults = viewModel.loadedViewModel.starshipData.results.filter { viewModel.searchText.isEmpty || $0.name.lowercased().contains(viewModel.searchText.lowercased()) }
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
        .searchable(text: $viewModel.searchText)    }
}

struct StarshipListView_Previews: PreviewProvider {
    static var previews: some View {
        StarshipListView()
    }
}
