//
//  CharactersListModel.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

struct Content: Decodable {
    var id: Int
    var name: String
    var species: String
    var type: String
    var gender: String
    var origin: OriginModel
    var image: String
    var episode: [String]
}

struct InfoModel: Decodable {
    var pages: Int
    var next: String
}

struct CharactersListModel: Decodable {
    var results: [Content]
    var info: InfoModel
}
