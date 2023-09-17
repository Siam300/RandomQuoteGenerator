//
//  Model.swift
//  quoteGenerator
//
//  Created by Auto on 9/17/23.
//

import Foundation

struct Quote: Decodable {
    let content: String
    let author: String
    let dateAdded: String
}

struct aPicture: Identifiable {
    var id: Int
    var name: String
    var imageName: String
}
