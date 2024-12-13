//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 11/12/24.
//
import SwiftUI

class ViewModel: ObservableObject {
    enum Status {
        case initial
        case loading
        case failure(error: Error)
        case success
    }
    
    @Published private(set) var status: Status = .initial
    
    private let fetcher = NetworkService()
    
    var quote: QuoteModel
    var character: CharacterModel
    var episode: EpisodeModel
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        quote = try! decoder.decode(
            QuoteModel.self, from: try! Data(contentsOf: Bundle.main.url(
                forResource: "samplequote", withExtension: "json")!))
        character = try! decoder.decode(
            CharacterModel.self, from: try! Data(contentsOf: Bundle.main.url(
                forResource: "samplecharacter", withExtension: "json")!))
        
        let death = try! decoder.decode(
            DeathModel.self, from: try! Data(contentsOf: Bundle.main.url(
                forResource: "sampledeath", withExtension: "json")!))
        
        character.death = death
        
        episode = try! decoder.decode(
            EpisodeModel.self, from: try! Data(contentsOf: Bundle.main.url(
                forResource: "sampleepisode", withExtension: "json")!))
        
    }
    
    func getQuoteData(for show: String) async {
        DispatchQueue.main.async {
            self.status = .loading
        }

        do {
            quote = try await fetcher.fetchQuote(from: show)
       
            character = try await fetcher.fetchCharacter(quote.character)
            character.death = try await fetcher.fetchDeath(for: quote.character)
            DispatchQueue.main.async {
                self.status = .success
            }
        
        } catch {
            DispatchQueue.main.async {
                self.status = .failure(error: error)
            }
        }
        
    }
    
    func getEpisodeData(for show: String) async {
        DispatchQueue.main.async {
            self.status = .loading
        }
        
        do {
            if let unwrappedEpisode = try await fetcher.fetchEpisode(from: show) {
                episode = unwrappedEpisode
                
                DispatchQueue.main.async {
                    self.status = .success
                }
            } else {
                DispatchQueue.main.async {
                    self.status = .failure(error: NetworkService.NetworkError.emptyEpisodesList)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.status = .failure(error: error)
            }
        }
    }
    
}
