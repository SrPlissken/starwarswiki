//
//  FilmListView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 22/1/23.
//

import SwiftUI

struct FilmListView: View {
    
    @ObservedObject var viewModel: FilmListViewModel = .init()
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
                    viewModel.loadFilmListData(for: 1)
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
                                        ClickableFilmItem(destination: RouterHelper.GetViewForDetailSection(category: "Film", data: viewModel.searchResults[index]), itemUrl: viewModel.loadImageForSelectedItem(for: index), itemName: viewModel.searchResults[index].title, itemImage: "film.stack")
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
                    viewModel.searchResults = viewModel.loadedViewModel.filmData.results.filter { viewModel.searchText.isEmpty || $0.title.lowercased().contains(viewModel.searchText.lowercased()) }
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
        .searchable(text: $viewModel.searchText)    }
}

struct FilmListView_Previews: PreviewProvider {
    static var previews: some View {
        FilmListView()
    }
}

struct ClickableFilmItem: View {
    
    let destination: AnyView
    let itemUrl: String
    let itemName: String
    let itemImage: String
    @State var newURL: String?
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 15) {
                AsyncImage(url: URL(string: newURL ?? "")) { image in
                    image
                        .resizable()
                        .padding([.leading, .trailing], -5)
                    
                } placeholder: {
                    Image(systemName: itemImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .offset(y: 4.0)
                }
                .frame(height: 230)
                // Perform image changes while searching
                .onChange(of: itemUrl, perform: { newValue in
                    DispatchQueue.main.async {
                        self.newURL = newValue
                    }
                })
                // Avoid possible xcode bug
                .onAppear() {
                    if newURL == nil {
                        DispatchQueue.main.async {
                            self.newURL = itemUrl
                        }
                    }
                }
                .offset(y: -5.0)
                Text(itemName)
                    .lineLimit(2)
                    .font(.title2)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.5)
                    .frame(height: 25)
                    .offset(y: -5.0)
            }
            .frame(maxWidth: .infinity)
            .padding(5)
            .foregroundColor(.orange)
            .background(Color.brown)
            .cornerRadius(20)
        }
    }
}

// TODO: To remove
struct ClickableItem: View {
    
    let destination: AnyView
    let itemUrl: String
    let itemName: String
    let itemImage: String
    @State private var newURL: String?
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 15) {
                AsyncImage(url: URL(string: newURL ?? "")) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: itemImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .offset(y: 4.0)
                }
                // Avoid possible xcode bug
                .onAppear() {
                    if newURL == nil {
                        DispatchQueue.main.async {
                            newURL = itemUrl
                        }
                    }
                }
                .offset(y: -4.0)
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
