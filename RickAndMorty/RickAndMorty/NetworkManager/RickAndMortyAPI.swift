//
//  API.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

enum RickAndMortyAPI: RESTConstructor {
    case getCharactersPagination(page: Int? = 1)
    case getCharacterInfo(URL: String? = nil)
    case getCharacterPlaceInfo(URL: String? = nil)
    case getCharacterImage(URL: String? = nil)
    case getEpisodesWithChaearacter(URL: String? = nil)
    
    var baseURL: String {
        switch self {
            case .getCharactersPagination:
                return "https://rickandmortyapi.com/api/"
            default: return ""
        }
        
    }
    
    var path: String {
        switch self {
            case .getCharactersPagination:
                return "character"
            case .getCharacterInfo(let URL), .getCharacterImage(let URL), .getCharacterPlaceInfo(let URL), .getEpisodesWithChaearacter(let URL):
                guard let URL else { return ""}
                return URL
        }
    }
    
    var params: [String : Any]? {
        var params = [String: Any]()
        switch self {
            case .getCharactersPagination(let page):
                params["page"] = page
            default: return nil
        }
        return params
    }
    
    var method: RequestPathType {
        switch self {
            case .getCharactersPagination:
                return .query
            case .getCharacterInfo(let URL), .getCharacterImage(let URL), .getCharacterPlaceInfo(let URL), .getEpisodesWithChaearacter(let URL):
                guard let URL else { return .body(bodyPath: nil) }
                return .body(bodyPath: URL)
        }
    }
    
    var requestType: RequestType {
        .get
    }
    
    static func createURL(request: RickAndMortyAPI) -> URLComponents {
        var components = URLComponents(string: "\(request.baseURL)\(request.path)\(request.method.requestPathType)")!
        
        guard let  parameters = request.params else {
            print(components.url!)
            return components
        }

        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value as? String)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        print(components.url!)
        return components
    }
    
}

