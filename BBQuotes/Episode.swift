//
//  Episode.swift
//  BBQuotes
//
//  Created by Jim Rainville on 2/18/25.
//
import Foundation

struct Episode: Decodable {
    let episode: Int // 101 - Season 1, Episode 1. 512 = Season 5 Episode 12. Use div and modulo to figure this out. 
    let title: String
    let image: URL
    let synopsis: String
    let writtenBy: String
    let directedBy: String
    let airDate: String
    
    var seasonEpisode: String {
        "Season \(episode / 100), Episode \(episode % 100)"
    }
}
