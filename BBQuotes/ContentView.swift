//
//  ContentView.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        
        GeometryReader { geo in
            TabView {
                QuoteView(vm: viewModel, show: "Breaking Bad")
                    .toolbarBackground(.black.opacity(0.5), for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .tabItem {
                        Label("Breaking Bad", systemImage: "tortoise")
                    }
                
                
                QuoteView(vm: viewModel, show: "Better Call Saul")
                    .toolbarBackground(.black.opacity(0.5), for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .tabItem {
                        Label("Better Call Saul", systemImage: "briefcase")
                    }
            }.frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
