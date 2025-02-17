//
//  CharacterView.swift
//  BBQuotes
//
//  Created by Jim Rainville on 1/26/25.
//

import SwiftUI

struct CharacterView: View {
    let character: Char
    let show: String
    
    var body: some View {
        GeometryReader { geo in
            // Adding a scroll view reader allows us to autoscroll to the bottom.
            ScrollViewReader { proxy in
                ZStack(alignment: .top) {
                    Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
                        .resizable()
                        .scaledToFit()
                    
                    ScrollView {
                        TabView {
                            ForEach(character.images, id: \.self) { characterImageURL in
                                
                                AsyncImage(url: characterImageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            
                        }
                        .tabViewStyle(.page)
                        .frame(width: geo.size.width/1.2, height: geo.size.height/1.7)
                        .clipShape(.rect(cornerRadius: 25))
                        .padding(.top, 60)
                        
                        VStack(alignment: .leading) {
                            Text(character.name)
                                .font(.largeTitle)
                            
                            Text("Portrayed By: \(character.portrayedBy)")
                                .font(.subheadline)
                            
                            Divider()
                            
                            Text("\(character.name) Character Info")
                                .font(.title2)
                            
                            Text("Born \(character.birthday)")
                            
                            Divider()
                            
                            Text("Occupations:")
                            
                            ForEach(character.occupations, id: \.self) { occupation in
                                Text("• \(occupation)")
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            
                            Text("Nicknames:")
                            
                            if character.aliases.count > 0 {
                                ForEach(character.aliases, id: \.self) { alias in
                                    Text("• \(alias)")
                                        .font(.subheadline)
                                }
                            } else {
                                Text("None")
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            
                            DisclosureGroup("Status (spoiler alert!):") {
                                VStack(alignment: .leading) {
                                    Text(character.status)
                                        .font(.title2)
                                    
                                    if let death = character.death {
                                        AsyncImage(url: death.image) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(.rect(cornerRadius: 15))
                                                // As soon as the death image appears scroll to the bottom.
                                                // 1 is the id of the detail view.
                                                .onAppear {
                                                    withAnimation() {
                                                        proxy.scrollTo(1, anchor: .bottom)
                                                    }
                                                    
                                                }
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        
                                        Text("How: \(death.details)")
                                            .padding(.bottom, 7)
                                        
                                        Text("Last words: \"\(death.lastWords)\"")
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 50)
                            }
                            .tint(.primary)
                            
                        }
                        .frame(width: geo.size.width/1.25, alignment: .leading)
                        .padding(.bottom, 50)
                        // The id will allow us to use this view to autoscroll to the bottom.
                        .id(1)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CharacterView(character: ViewModel().character, show: "Breaking Bad")
}
