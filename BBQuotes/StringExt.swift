//
//  StringExt.swift
//  BBQuotes
//
//  Created by Lorusso, Michele on 13/12/24.
//

extension String {
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpace() -> String {
        self.lowercased().removeSpaces()
    }
}
