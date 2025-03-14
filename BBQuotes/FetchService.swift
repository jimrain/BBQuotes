//
//  FetchService.swift
//  BBQuotes
//
//  Created by Jim Rainville on 1/26/25.
//

import Foundation

struct FetchService {
    private enum FetchError: Error {
        case badResponse
    }
    
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    private func shouldQuoteSimpsons() -> Bool {
        // This function will return true randomly about 10% of the time. 
        var simpsons = false
        let randomInt = Int.random(in: 1...10)
        if randomInt == 1 {
            simpsons = true
        }
        return simpsons
        // return true
    }
    
    func fetchSimpsonsQuote() async throws -> String {
        let fetchURL = URL(string: "https://thesimpsonsquoteapi.glitch.me/quotes")!
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        let simpsonsQuote = try JSONDecoder().decode([Quote].self, from: data)
        
        // print("Getting Simpsons Quote...")
        return simpsonsQuote[0].quote
    }
    
    // https://breaking-bad-api-six.vercel.app/api/quotes/random?production=Breaking+Bad
    func fetchQuote(from show: String) async throws -> Quote {
        // Build fetch url
        
        // var fetchURL: URL
        // var quote: Quote
        
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
    
        // Fetch data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        // Handle Response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        /* JMR - cool way to print out response body.
        let responseData = String(data: data, encoding: String.Encoding(rawValue: NSUTF8StringEncoding))!
        print("Data: \(responseData)")
         */
        
        // Decode Data

        var quote = try JSONDecoder().decode(Quote.self, from: data)
        
        if shouldQuoteSimpsons() {
            quote.quote = try await fetchSimpsonsQuote()
        }
        // return quote
        return quote
    }
    
    func fetchQuote(for character: String) async throws -> Quote {
        // https://breaking-bad-api-six.vercel.app/api/quotes/random?character=Walter+White
        // Build fetch url
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "character", value: character)])
        
        // Fetch data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // Handle Response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        // Decode Data
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        // return quote
        return quote
    }
    
    func fetchCharacter(_ name: String) async throws -> Char {
        let characterURL = baseURL.appending(path: "characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
       
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // The api returns an array of 1 so decode it that way then return the first element.
        let characters = try decoder.decode([Char].self, from: data)
        
        return characters[0]
    }
    
    func fetchRandomCharacter() async throws -> Char {
        let randomCharacterURL = baseURL.appending(path: "characters/random")
        let (data, response) = try await URLSession.shared.data(from: randomCharacterURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // The api returns an array of 1 so decode it that way then return the first element.
        let character = try decoder.decode(Char.self, from: data)
        
        return character
    }
    
    func fetchDeath(for character: String) async throws -> Death! {
        let fetchURL = baseURL.appending(path: "deaths")
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let deaths = try decoder.decode([Death].self, from: data)
        
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        
        return nil
    }
    
    func fetchEpisode(from show: String) async throws -> Episode? {
        let episodeURL = baseURL.appending(path: "episodes")
        let fetchURL = episodeURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // The api returns an array of 1 so decode it that way then return the first element.
        let episodes = try decoder.decode([Episode].self, from: data)
        
        return episodes.randomElement()
    }
    
}
