//
//  CharacterFrontView.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 13/12/24.
//

import SwiftUI

struct CharacterFrontView: View {
    var character: CharacterModel
    @State var showCharacterInfo = false
    let show: String
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {

                    ZStack(alignment: .bottom) {
                        AsyncImage(url: character.images.randomElement()) {
                            image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }.frame(width: geo.size.width * 0.8, height: geo.size.height * 0.7)
                        
                        Text(character.name).foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                    }
                    .clipShape(.rect(cornerRadius: 50))
                    .onTapGesture {
                        showCharacterInfo.toggle()
                        
                    }
                }
                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.9)
            }.frame(width: geo.size.width, height: geo.size.height)
                .sheet(isPresented: $showCharacterInfo) {
                    CharacterDetailView(character: character, show: show)
                }
        }
    }
}

#Preview {
    let vm = ViewModel()
    CharacterFrontView( character: vm.character, show: Constants.bbName)
}
