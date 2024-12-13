//
//  CharacterView.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 12/12/24.
//

import SwiftUI

struct CharacterDetailView: View {
    var character: CharacterModel
    var show: String

    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ZStack(alignment: .top) {
                    Image(show.removeCaseAndSpace())
                        .resizable()
                        .scaledToFit()
                    
                    ScrollView {
                        VStack {
                            TabView {
                                ForEach(character.images, id: \.self) { imageURL in
                                    AsyncImage(url: imageURL) { image in
                                        image.resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                            .tabViewStyle(.page)
                            .cornerRadius(25)
                            .frame(
                                width: geo.size.width * 0.8,
                                height: geo.size.height * 0.6
                            )
                            .padding(.top, 60)
                            
                            VStack(alignment: .leading) {
                                Text(character.name)
                                    .font(.largeTitle)
                                    .padding(.top)
                                
                                Text("Portrayed by \(character.portrayedBy)")
                                    .padding(.bottom)
                                
                                Text("\(character.name) character info:")
                                    .font(.title2)
                                
                                Text("Born: \(character.birthday)")
                                    .padding(.bottom)
                                
                                Text("Occupations:")
                                    .font(.title2)
                                ForEach(character.occupations, id: \.self) {
                                    occupation in
                                    Text("• \(occupation)")
                                }
                                
                                Text("Nicknames:")
                                    .font(.title2)
                                    .padding(.top)
                                
                                ForEach(character.aliases, id: \.self) { alias in
                                    Text("• \(alias)")
                                }
                                
                                DisclosureGroup("Character Status, Spoiler Alert!")
                                {
                                    VStack(alignment: .leading) {
                                        Text(character.status).padding(.top)
                                        
                                        if let death = character.death {
                                            AsyncImage(url: death.image) {
                                                image in
                                                image.resizable()
                                                    .scaledToFill()
                                                    .onAppear {
                                                        withAnimation {
                                                            proxy.scrollTo(1, anchor: .bottom)
                                                        }
                                                    }
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            
                                            Text("How: \(death.details)")
                                            
                                            Text(
                                                "Last Words: \"\(death.lastWords)\""
                                            ).padding(.top)
                                        }
                                    }.frame(
                                        maxWidth: .infinity, alignment: .leading)
                                }
                                .tint(.primary)
                                .font(.title2)
                                .padding(.bottom, 50)
                                
                            }
                            .frame(width: geo.size.width * 0.8)
                        }.id(1)
                    }.scrollIndicators(.hidden)
                    
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CharacterDetailView(character: ViewModel().character, show: Constants.bbName)
        .preferredColorScheme(.dark)
}
