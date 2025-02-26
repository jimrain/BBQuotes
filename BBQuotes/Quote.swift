//
//  Quote.swift
//  BBQuotes
//
//  Created by Jim Rainville on 1/26/25.
//

struct Quote: Decodable {
    // quote needs to be a var because we might change it if it's a simpsons quote. 
    var quote: String
    let character: String
}
