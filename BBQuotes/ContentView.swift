//
//  ContentView.swift
//  BBQuotes
//
//  Created by Jim Rainville on 1/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Breaking Bad", systemImage: "tortoise"){
                Text("Breaking Bad View")
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            Tab("Better Call Saul", systemImage: "briefcase") {
                Text("Better Call Saul View")
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
