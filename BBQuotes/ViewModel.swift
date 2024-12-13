//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 11/12/24.
//
import SwiftUI

@Observable
class ViewModel {
    enum Status {
        case initial
        case loading
        case failure(error: Error)
        case success
    }
    
    private(set) var status: Status = .initial
    
    private let fetcher = NetworkService()
    
    var quote: QuoteModel
    var character: CharacterModel
    
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
    }
    
    func getData(for show: String) async {
        status = .loading
        do {
            quote = try await fetcher.fetchQuote(from: show)
       
            character = try await fetcher.fetchCharacter(quote.character)
            character.death = try await fetcher.fetchDeath(for: quote.character)
            status = .success
        
        } catch {
            status = .failure(error: error)
        }
        
        print(status)
    }
    
}
