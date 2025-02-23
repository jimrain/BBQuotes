//
//  BBQuotesApp.swift
//  BBQuotes
//
//  Created by Jim Rainville on 1/26/25.
//

import SwiftUI

@main
struct BBQuotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/*
 Version 2 Feature List:
 ✅ Add El Camino Tab
 ✅ Utilized all character images on Character View
 ✅ On CharcterView, auto-scroll to bottom after status is shown.
 ✅ Fetch Episode Data
 ✅ Extend String to get rid of long image and color names
 ✅ Create static constants for show names.
 */

/*
 Coding Challenges:
 ✅ Fetch a quote automatically when the app launchs.
 ✅ When you fetch a quote have it show a random image instead of the first one.
 ✅ Fetch a random Character
 ✅ On the character screen, add a place to put one of the characters quotes plus add a button to fetch another
   random quote fromt he same character. Here is the url to get a random quote for a character:
   https://breaking-bad-api-six.vercel.app/api/quotes/random?character=Walter+White
 - Sometimes have it randomly fetch a simpsons quote instead of a bb quote (i.e. every fifth quote is a Simpsons quote or probability base - 80% BB 20% Simpsons.
   https://thesimpsonsquoteapi.glitch.me/quotes
 */


