//
//  ButtonLabel.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 13/12/24.
//

import SwiftUI

struct ButtonLabel: View {
    var show: String
    var text: String
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .lineLimit(1)
            .foregroundStyle(.white)
            .padding()
            .background(
                Color("\(show.removeSpaces())Button")
            )
            .clipShape(.rect(cornerRadius: 12))
            .shadow(
                color: Color("\(show.removeSpaces())Shadow"), radius: 2)
            .minimumScaleFactor(0.5)
    }
}

#Preview {
    ButtonLabel(show: "Breaking Bad", text: "Get Random Character")
}
