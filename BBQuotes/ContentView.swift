//
//  ContentView.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        GeometryReader { geo in
            TabView {
                FetchView(vm:  ViewModel(), show: Constants.bbName)
                    .toolbarBackground(.black.opacity(0.5), for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .tabItem {
                        Label(Constants.bbName, systemImage: "tortoise")
                    }
                
                
                FetchView(vm:  ViewModel(), show: Constants.bcsName)
                    .toolbarBackground(.black.opacity(0.5), for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .tabItem {
                        Label(Constants.bcsName, systemImage: "briefcase")
                    }
                
                FetchView(vm:  ViewModel(), show: Constants.ecName)
                    .toolbarBackground(.black.opacity(0.5), for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .tabItem {
                        Label(Constants.ecName, systemImage: "car")
                    }
            }.frame(width: geo.size.width, height: geo.size.height)
        }.preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
