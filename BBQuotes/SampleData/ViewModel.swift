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
        case success
        case fail(error: Error)
    }
    
    // Private(set) makes this variable get-able but not setable
    private(set) var status: FetchStatus = .notStarted
    
    private let fetcher = FetchService()
    
    var quote: Quote
    var character: Char
    
    init() {
        
    }
}
