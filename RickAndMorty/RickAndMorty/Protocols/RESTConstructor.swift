//
//  RESTConstructor.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

enum RequestPathType {
    case query
    case body(bodyPath: String? = nil)
    
    var requestPathType: String {
        switch self {
            case .query:
                return "?"
            case .body(bodyPath: let bodyPath):
                guard let bodyPath else { return ""}
                return bodyPath
        }
    }
}

enum RequestType {
    case post
    case get
    
    var requestType: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
        }
    }
}

protocol RESTConstructor {
    var baseURL: String { get }
    var path: String { get }
    var params: [String: Any]? { get }
    var method: RequestPathType { get }
    var requestType: RequestType { get }
    
    static func createURL(request: Self) -> URLComponents
}
