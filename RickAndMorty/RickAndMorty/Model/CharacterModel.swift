//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

struct CharacterModel: Decodable {
    var species: String
    var type: String
    var gender: String
}
