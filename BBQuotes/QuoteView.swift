//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 12/12/24.
//

import SwiftUI

struct QuoteView: View {
    @ObservedObject var vm: ViewModel
    let show: String
    @State var showCharacterInfo = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
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
                        case ViewModel.Status.success:
                            VStack {
                                Text("\(vm.quote.quote)")
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(.black.opacity(0.5))
                                    .clipShape(.rect(cornerRadius: 25))
                                    .minimumScaleFactor(0.5)
                                ZStack(alignment: .bottom) {
                                    AsyncImage(url: vm.character.images[0]) {
                                        image in
                                        image.resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(
                                        width: geo.size.width * 0.9,
                                        height: geo.size.height * 0.6)
                                    
                                    Text(vm.character.name).foregroundStyle(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(.ultraThinMaterial)
                                }
                                .clipShape(.rect(cornerRadius: 50))
                                .onTapGesture {
                                    showCharacterInfo.toggle()
                                    
                                }
                            }.frame(width: geo.size.width * 0.9)
                        case .failure(let error):
                            Text(error.localizedDescription)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                        }
                        
                        Spacer()
                    }

                    Button {
                        Task {
                            await vm.getData(for: show)
                        }
                    } label: {
                        Text("Get Random Quote")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                Color(
                                    show == "Breaking Bad"
                                    ? "BreakingBadButton"
                                    : "BetterCallSaulButton")
                            )
                            .clipShape(.rect(cornerRadius: 12))
                            .shadow(
                                color: Color(
                                    show == "Breaking Bad"
                                    ? "BreakingBadShadow"
                                    : "BetterCallSaulShadow"), radius: 2)
                    }
                    
                    Spacer(minLength: 90)

                }.frame(width: geo.size.width, height: geo.size.height)
            }.frame(width: geo.size.width, height: geo.size.height)
        }.ignoresSafeArea()
            .sheet(isPresented: $showCharacterInfo) {
                CharacterView(character: vm.character, show: show)
            }
    }
}

#Preview {
    QuoteView(vm: ViewModel(), show: "Breaking Bad")
        .preferredColorScheme(.dark)
}
