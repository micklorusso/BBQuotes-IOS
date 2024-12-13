//
//  NetworkService.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 11/12/24.
//

import Foundation

struct NetworkService {
    enum NetworkError: Error {
        case badResponse
        case emptyEpisodesList
    }
    
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    private let simpsonBaseURL = URL(string: "https://thesimpsonsquoteapi.glitch.me")!
    
    func fetchQuote(from show: String, characterName: String? = nil) async throws -> QuoteModel {
        var fetchURL = baseURL.appending(path: "quotes/random")
        if characterName != nil {
            fetchURL = fetchURL.appending(queryItems: [URLQueryItem(name: "character", value: characterName)])
        } else {
            fetchURL = fetchURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        }
        
        return try await fetch(with: fetchURL)
    }
    
    func fetchQuoteSimpson() async throws -> SimpsonQuoteModel {
        let fetchURL = simpsonBaseURL.appending(path: "quotes")
        
        let quoteList: [SimpsonQuoteModel] = try await fetch(with: fetchURL)
        return quoteList[0]
    }
    
    func fetchCharacter(_ name: String) async throws -> CharacterModel {
        let fetchURL = baseURL.appending(path: "characters").appending(queryItems: [URLQueryItem(name: "name", value: name)])
        
        let characterList: [CharacterModel] = try await fetch(with: fetchURL)
        return characterList[0]
    }
    
    func fetchRandomCharacter() async throws -> CharacterModel {
        let fetchURL = baseURL.appending(path: "characters/random")
        
        return try await fetch(with: fetchURL)
    }
    
    func fetchDeath(for character: String) async throws -> DeathModel? {
        let fetchURL = baseURL.appending(path: "deaths")
        let deaths: [DeathModel] = try await fetch(with: fetchURL)
        
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        
        return nil
    }
    
    func fetchEpisode(from show: String) async throws -> EpisodeModel? {
        let fetchURL = baseURL.appending(path: "episodes").appending(queryItems: [URLQueryItem(name: "production", value: show)])
        
        let episodes: [EpisodeModel] = try await fetch(with: fetchURL)
        return episodes.randomElement()
    }
    
    
    func fetch<T: Decodable>(with fetchURL: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let model = try decoder.decode(T.self, from: data)
        
        return model
    }
}
