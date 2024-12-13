//
//  CharacterView.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 12/12/24.
//

import SwiftUI

struct CharacterView: View {
    var character: CharacterModel
    var show: String

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
                    .resizable()
                    .scaledToFit()

                ScrollView {
                    VStack(spacing: 0) {
                        AsyncImage(url: character.images[0]) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .cornerRadius(25)
                        .background(.black.opacity(0.5))
                        .clipShape(
                            RoundedCornerShape(
                                corners: [.topLeft, .topRight], radius: 25)
                        )
                        .padding(.top, 60)
                        .frame(
                            width: geo.size.width * 0.8,
                            height: geo.size.height * 0.6)

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
                                        } placeholder: {
                                            ProgressView()
                                        }

                                        Text("How: \(death.details)")
                                        
                                        Text("Last Words: \"\(death.lastWords)\"").padding(.top)
                                    }
                                }.frame(
                                    maxWidth: .infinity, alignment: .leading)
                            }
                            .tint(.primary)
                            .font(.title2)
                            .padding(.bottom, 50)

                        }
                        .frame(width: geo.size.width * 0.8)
                        .background(.black.opacity(0.5))
                    }
                }.scrollIndicators(.hidden)

            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CharacterView(character: ViewModel().character, show: "Breaking Bad")
        .preferredColorScheme(.dark)
}
