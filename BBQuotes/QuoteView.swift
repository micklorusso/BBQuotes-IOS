//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 13/12/24.
//

import SwiftUI

struct QuoteView: View {
    var quote: QuoteModel
    var character: CharacterModel
    @State var showCharacterInfo = false
    let show: String
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Text("\(quote.quote)")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .padding()
                        .background(.black.opacity(0.5))
                        .clipShape(.rect(cornerRadius: 25))
                        .minimumScaleFactor(0.5)
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: character.images[0]) {
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
                CharacterView(character: character, show: show)
            }
        }
    }
}

#Preview {
    let vm = ViewModel()
    QuoteView(quote: vm.quote, character: vm.character, show: Constants.bbName)
}
