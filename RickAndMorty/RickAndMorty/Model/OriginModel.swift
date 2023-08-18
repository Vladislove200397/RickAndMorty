//
//  OriginModel.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

struct OriginModel: Decodable {
    var url: String
}

struct OriginRequestModel: Decodable {
    var name: String
    var type: String
}
