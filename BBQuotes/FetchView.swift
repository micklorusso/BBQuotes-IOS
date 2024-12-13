//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 12/12/24.
//

import SwiftUI

struct FetchView: View {
    @ObservedObject var vm: ViewModel
    let show: String

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.removeCaseAndSpace())
                    .resizable()
                    .frame(
                        width: geo.size.width * 2, height: geo.size.height * 1.2
                    )

                VStack {
                    VStack {
                        Spacer(minLength: 65)
                        
                        switch vm.status {
                        case ViewModel.Status.initial:
                            EmptyView()
                        case ViewModel.Status.loading:
                            ProgressView()
                        case ViewModel.Status.successQuote:
                            QuoteView(quote: vm.quote, character: vm.character, show: show)
                        case ViewModel.Status.successEpisode:
                            EpisodeView(episode: vm.episode)
                        case ViewModel.Status.successCharacter:
                            CharacterFrontView(character: vm.character, show: show)
                        case .successQuoteSimpson:
                            QuoteViewSimpson(quote: vm.simpsonQuote)
                        case .failure(let error):
                            Text(error.localizedDescription)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                        }
                        
                        Spacer()
                    }

                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 5),
                        GridItem(.flexible(), spacing: 5)
                    ], spacing: 5) {
                        
                        Button {
                            Task {
                                await vm.getQuoteData(for: show)
                            }
                        } label: {
                            ButtonLabel(show: show, text: "Get Random Quote")
                        }
                        
                        Button {
                            Task {
                                await vm.getEpisodeData(for: show)
                            }
                        } label: {
                            ButtonLabel(show: show, text: "Get Random Episode")
                        }
                        
                        Button {
                            Task {
                                await vm.getQuoteData(for: show, characterName: vm.character.name)
                            }
                        } label: {
                            ButtonLabel(show: show, text: "Get another Quote")
                        }
                        
                        Button {
                            Task {
                                await vm.getRandomCharacter(for: show)
                            }
                        } label: {
                            ButtonLabel(show: show, text: "Get Random Character")
                        }
                    }
                    .padding()
                    
                    Spacer(minLength: 90)

                }.frame(width: geo.size.width, height: geo.size.height)
            }.frame(width: geo.size.width, height: geo.size.height)
        }.ignoresSafeArea()
            .onAppear {
                Task {
                    await vm.getQuoteData(for: show)
                }
            }
    }
}

#Preview {
    FetchView(vm: ViewModel(), show: Constants.bbName)
        .preferredColorScheme(.dark)
}
