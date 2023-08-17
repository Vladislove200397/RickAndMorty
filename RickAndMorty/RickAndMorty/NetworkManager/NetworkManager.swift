//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

actor NetworkManager<T: Decodable> {
    func getData(_ request: RickAndMortyAPI) async throws -> T {
        let urlRequest = URLRequest(url: RickAndMortyAPI.createURL(request: request).url!)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        guard let succesData = try? JSONDecoder().decode(T.self, from: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        return succesData
    }
}
