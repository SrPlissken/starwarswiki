//
//  ContentView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 2/1/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: MainViewModel = .init()

    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color.black
                    .ignoresSafeArea()
                
                // Main layout
                VStack {
                    Image("StarWarsMain")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .padding(30)
                    
                    Spacer()
                    
                    // Grid layout
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(viewModel.categoryTitle.indices, id: \.self) { index in
                            CategoryButton(destination: RouterHelper.GetViewForSelection(index: index), categoryUrl: viewModel.categoryUrls[index], categoryPlaceHolder: viewModel.categoryPlaceHolders[index], categoryTitle: viewModel.categoryTitle[index])
                        }
                    }
                    .padding(30)
                    
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Category button
struct CategoryButton: View {
    
    // Image and title
    let destination: AnyView
    let categoryUrl: String
    let categoryPlaceHolder: String
    let categoryTitle: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 15) {
                AsyncImage(url: URL(string:categoryUrl)) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: categoryPlaceHolder)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .offset(y: 4.0)
                }
                .offset(y: -4.0)
                
                Text(categoryTitle)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 130)
            .foregroundColor(.orange)
            .background(Color.brown)
            .cornerRadius(20)
        }
    }
}
