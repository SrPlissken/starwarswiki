//
//  CharacterDetailView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 7/1/23.
//

import SwiftUI

struct CharacterDetailView: View {
    
    @ObservedObject var viewModel: CharacterDetailViewModel
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 10) {
                    // Character image
                    Image(systemName: "person.2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding()
                    
                    // Character name
                    Text(viewModel.selectedCharacter.name)
                        .font(.title)
                        .padding(.bottom, 30)
                    
                    // Character data
                    VStack {
                        CharacterProperty(propertyName: "Height", propertyValue: viewModel.selectedCharacter.height)
                        CharacterProperty(propertyName: "Mass", propertyValue: viewModel.selectedCharacter.mass)
                        CharacterProperty(propertyName: "Hair Color", propertyValue: viewModel.selectedCharacter.hair_color)
                        CharacterProperty(propertyName: "Skin Color", propertyValue: viewModel.selectedCharacter.skin_color)
                        CharacterProperty(propertyName: "Eye Color", propertyValue: viewModel.selectedCharacter.eye_color)
                        CharacterProperty(propertyName: "Birth Year", propertyValue: viewModel.selectedCharacter.birth_year)
                        CharacterProperty(propertyName: "Gender", propertyValue: viewModel.selectedCharacter.gender)
                    }
                    .padding(.bottom, 30)
                    
                    // Other character data
                    VStack(spacing: 40) {
                        DetailNavigableCategoryItems(categoryName: "Homeworld")
                        DetailNavigableCategoryItems(categoryName: "Films")
                        DetailNavigableCategoryItems(categoryName: "Species")
                        DetailNavigableCategoryItems(categoryName: "Starships")
                        DetailNavigableCategoryItems(categoryName: "Vehicles")
                    }
                    
                    
                    
                }
                .navigationBarTitle(Text(viewModel.selectedCharacter.name), displayMode: .inline)
                .background(.black)
                .foregroundColor(.white)
                .preferredColorScheme(.dark)
                .padding([.leading, .trailing], 20)
            }
        }
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(viewModel: CharacterDetailViewModel(selectedCharacter: Character.SampleData))
    }
}

// Simple character property view
struct CharacterProperty: View {
    
    let propertyName: String
    let propertyValue: String
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(propertyName)
                    .font(.body)
                Spacer()
                Text(propertyValue)
                    .font(.body)
            }
            Rectangle()
                .frame(height: 1)
        }
    }
}

// View with category accesible items
struct DetailNavigableCategoryItems: View {
    
    let categoryName: String
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(categoryName)
                    .font(.title)
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ClickableItem(destination: AnyView(EmptyView()), itemName: "Planet1", itemImage: "globe")
                        .frame(width: 200)
                    ClickableItem(destination: AnyView(EmptyView()), itemName: "Planet1", itemImage: "globe")
                        .frame(width: 200)
                }
            }
        }
    }
}
