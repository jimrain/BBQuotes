//
//  StringExt.swift
//  BBQuotes
//
//  Created by Jim Rainville on 2/17/25.
//

extension String {
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpace() -> String {
        self.removeSpaces().lowercased()
    }
}
