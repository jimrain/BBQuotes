//
//  Char.swift
//  BBQuotes
//
//  Created by Jim Rainville on 1/26/25.
//
import Foundation

struct Char: Decodable {
    let name: String
    let birthday: String
    let occupations: [String]
    let images: [URL]
    let aliases: [String]
    let status: String
    let portrayedBy: String
}
