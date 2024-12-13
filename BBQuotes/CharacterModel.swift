//
//  CharacterModel.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 11/12/24.
//

import Foundation

struct CharacterModel: Codable {
    let name: String
    let birthday: String
    let occupations: [String]
    let images: [URL]
    let aliases: [String]
    let status: String
    let portrayedBy: String
    var death: DeathModel?
    let productions: [String]
}
