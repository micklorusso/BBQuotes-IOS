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
        case successQuote
        case successEpisode
        case successCharacter
        case successQuoteSimpson
    }
    
    @Published private(set) var status: Status = .initial
    
    private let fetcher = NetworkService()
    
    var quote: QuoteModel
    var character: CharacterModel
    var simpsonQuote: SimpsonQuoteModel
    var episode: EpisodeModel
    
    var fetchQuoteCounter = 0
    
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
        
        simpsonQuote = try! decoder.decode(
            SimpsonQuoteModel.self, from: try! Data(contentsOf: Bundle.main.url(
                forResource: "samplesimpsonquote", withExtension: "json")!))
    }
    
    func getQuoteData(for show: String, characterName: String? = nil) async {
        DispatchQueue.main.async {
            self.status = .loading
        }

        do {
            
            if (fetchQuoteCounter < 4) {
                quote = try await fetcher.fetchQuote(from: show, characterName: characterName)
                
                character = try await fetcher.fetchCharacter(quote.character)
                character.death = try await fetcher.fetchDeath(for: quote.character)
                DispatchQueue.main.async {
                    self.status = .successQuote
                }
                fetchQuoteCounter += 1
            } else {
                fetchQuoteCounter = 0
                
                simpsonQuote = try await fetcher.fetchQuoteSimpson()
                
                DispatchQueue.main.async {
                    self.status = .successQuoteSimpson
                }

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
                    self.status = .successEpisode
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
    
    
    func getRandomCharacter(for show: String) async {
        DispatchQueue.main.async {
            self.status = .loading
        }
        
        do {
            var characterForProductionFound = false
            while !characterForProductionFound {
                character = try await fetcher.fetchRandomCharacter()
                if character.productions.contains(show) {
                    characterForProductionFound = true
                }
            }
            DispatchQueue.main.async {
                self.status = .successCharacter
            }
        } catch {
            DispatchQueue.main.async {
                self.status = .failure(error: error)
            }
        }
    }
}
