//
//  QuoteViewSimpson.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 13/12/24.
//

import SwiftUI

struct QuoteViewSimpson: View {
    var quote: SimpsonQuoteModel
    
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
                        AsyncImage(url: quote.image) {
                            image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }.frame(width: geo.size.width * 0.8, height: geo.size.height * 0.7)
                        
                        Text(quote.character).foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                    }
                    .clipShape(.rect(cornerRadius: 50))
                }
                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.9)
            }.frame(width: geo.size.width, height: geo.size.height)
        }
    }
}


#Preview {
    QuoteViewSimpson(quote: ViewModel().simpsonQuote)
}
