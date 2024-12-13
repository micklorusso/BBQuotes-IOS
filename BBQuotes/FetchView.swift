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
                        case .failure(let error):
                            Text(error.localizedDescription)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                        }
                        
                        Spacer()
                    }

                    HStack(alignment: .center) {
                        Spacer()
                        
                        Button {
                            Task {
                                await vm.getQuoteData(for: show)
                            }
                        } label: {
                            Text("Get Random Quote")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                                .background(
                                    Color("\(show.removeSpaces())Button")
                                )
                                .clipShape(.rect(cornerRadius: 12))
                                .shadow(
                                    color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await vm.getEpisodeData(for: show)
                            }
                        } label: {
                            Text("Get Random Episode")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                                .background(
                                    Color("\(show.removeSpaces())Button")
                                )
                                .clipShape(.rect(cornerRadius: 12))
                                .shadow(
                                    color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                        Spacer()
                    }
                    
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
