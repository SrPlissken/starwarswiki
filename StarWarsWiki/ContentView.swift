//
//  ContentView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 2/1/23.
//

import SwiftUI

struct ContentView: View {
    
    let categoryImages = ["person.2", "airplane.departure", "globe", "film.stack", "lizard", "airplane"]
    let categoryTitle = ["Characters", "Starships", "Planets", "Films", "Species", "Vehicles"]
    
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
                        ForEach(categoryImages, id: \.self) { item in
                            let index = categoryImages.firstIndex(of: item) ?? 0
                            CategoryButton(destination: RouterHelper.GetViewForSelection(index: index), categoryImage: categoryImages[index], categoryTitle: categoryTitle[index])
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
    let categoryImage: String
    let categoryTitle: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 15) {
                Image(systemName: categoryImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text(categoryTitle)
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
