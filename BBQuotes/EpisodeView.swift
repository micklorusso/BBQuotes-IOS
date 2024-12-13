//
//  EpisodeView.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 13/12/24.
//

import SwiftUI

struct EpisodeView: View {
    var episode: EpisodeModel
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack(alignment: .leading) {
                    Text(episode.title)
                        .font(.largeTitle)
                    Text(episode.seasonEpisode)
                        .font(.title2)
                    AsyncImage(url: episode.image) { image in
                        image.resizable()
                            .scaledToFit()
                            .cornerRadius(25)
                    } placeholder: {
                        ProgressView()
                    }

                    Text(episode.synopsis)
                        .minimumScaleFactor(0.5)
                        .padding(.bottom)
                    
                    Text("Written by: \(episode.writtenBy)")
                    
                    Text("Directed by: \(episode.directedBy)")
                    Text("Aired: \(episode.airDate)")
                }.frame(width: geo.size.width * 0.8, height: geo.size.height * 0.7)
                    .padding()
                    .background(.black.opacity(0.5))
                    .cornerRadius(25)
            }.frame(width: geo.size.width, height: geo.size.height)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    EpisodeView(episode: ViewModel().episode)
}
