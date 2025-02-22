//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Jim Rainville on 1/26/25.
//
import Foundation

// Observable makes this visiable by other views (like @State) and @MainActor makes it the same
// priority as the UI
@Observable
@MainActor
class ViewModel {
    enum FetchStatus {
        case notStarted
        case fetching
        case successQuote
        case successEpisode
        case successCharacter
        case fail(error: Error)
    }
    
    // Private(set) makes this variable get-able but not setable
    private(set) var status: FetchStatus = .notStarted
    
    private let fetcher = FetchService()
    
    var quote: Quote
    var character: Char
    var episode: Episode
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(Quote.self, from: quoteData)
        
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(Char.self, from: characterData)
        
        let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        episode = try! decoder.decode(Episode.self, from: episodeData)
    }
    
    func getQuoteData(for show: String) async {
        status = .fetching
        
        do {
            quote = try await fetcher.fetchQuote(from: show)
            character = try await fetcher.fetchCharacter(quote.character)
            character.death = try await fetcher.fetchDeath(for: character.name)
            status = .successQuote
        } catch {
            status = .fail(error: error)
        }
    }
    
    func getEpisode(for show: String) async {
        status = .fetching
        
        do {
            if let unwrappedEpisode = try await fetcher.fetchEpisode(from: show) {
                episode = unwrappedEpisode
            }
            status = .successEpisode
        } catch {
            status = .fail(error: error)
        }
    }
    
    func getCharacter(for show: String) async {
        status = .fetching
        let maxRetries = 10
        var numRetries = 0
        
        repeat {
            do {
                character = try await fetcher.fetchRandomCharacter()
                if character.productions.contains(show) {
                    character.death = try await fetcher.fetchDeath(for: character.name)
                    status = .successCharacter
                    break
                }
            } catch {
                status = .fail(error: error)
            }
            numRetries += 1
        } while numRetries < maxRetries
        
        switch status {
        case .fetching:
            status = .fail(error: NSError(domain: "Character not found", code: 404, userInfo: nil))
        default:
            status = status
        }
    }
}
