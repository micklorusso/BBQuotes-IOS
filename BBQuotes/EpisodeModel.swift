//
//  EpisodeModel.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 13/12/24.
//

import Foundation

struct EpisodeModel: Codable {
    let title: String
    let synopsis: String
    let episode: Int
    let writtenBy: String
    let directedBy: String
    let airDate: String
    let image: URL
    
    var seasonEpisode: String {
        var episodeString = String(episode)
        let season = episodeString.removeFirst()
        if episodeString.first! == "0" {
            episodeString.removeFirst()
        }
        
        return "Season \(season) Episode \(episodeString)"
    }
}
