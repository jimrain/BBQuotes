//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Jim Rainville on 1/26/25.
//

import SwiftUI

struct FetchView: View {
    let vm = ViewModel()
    let show: String
    
    @State var showCharacterInfo = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.removeCaseAndSpace())
                .resizable()
                .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                
                VStack {
                    VStack {
                        Spacer(minLength: 60)
                        
                        switch vm.status {
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                        case .successQuote:
                            Text("\"\(vm.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottom) {
                                // Coding challange 2 - changed from image[0] to randomImage. Super easy!
                                AsyncImage(url: vm.character.images.randomElement()) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                                
                                Text(vm.quote.character)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                        
                        case .successEpisode:
                            EpisodeView(episode: vm.episode)
                            
                        case .fail(let error):
                            Text(error.localizedDescription)
                        }
                        
                        
                        Spacer(minLength: 20)
                        
                        HStack {
                            Button {
                                Task {
                                    await vm.getQuoteData(for: show)
                                }
                                
                            } label: {
                                Text("Get Random Quote")
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(Color("\(show.removeSpaces())Button"))
                                    .clipShape(.rect(cornerRadius: 7))
                                    .shadow(color: Color("\(show.removeSpaces())Button"), radius: 2)
                            }
                            
                            Spacer()
                            
                            Button {
                                Task {
                                    await vm.getEpisode(for: show)
                                }
                                
                            } label: {
                                Text("Get Random Episode")
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(Color("\(show.removeSpaces())Button"))
                                    .clipShape(.rect(cornerRadius: 7))
                                    .shadow(color: Color("\(show.removeSpaces())Button"), radius: 2)
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer(minLength: 95)
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            // For coding challenge 1 - when the view loads get a random quote automatically. 
            .task {
                await vm.getQuoteData(for: show)
            }
        }
        .ignoresSafeArea()
        .toolbarBackgroundVisibility(.visible, for: .tabBar)
        .sheet(isPresented: $showCharacterInfo) {
            CharacterView(character: vm.character, show: show)
        }
    }
}

#Preview {
    FetchView(show: Constants.bbName)
        .preferredColorScheme(.dark)
}
