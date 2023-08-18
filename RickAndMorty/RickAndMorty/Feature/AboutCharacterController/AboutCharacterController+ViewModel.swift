//
//  AboutCharacterController+ViewModel.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import UIKit

extension AboutCharacterController {
    class ViewModel: BasicViewModel {
        private var loadTask: Task<Void, Never>?
        private var episodesTask: Task<Void, Never>?
        private var loadImageTask: Task<Void, Never>?
        private static let imageLoader = ImageLoaderService(cacheCountLimit: 1)
        private var getOriginManager: NetworkManager<OriginRequestModel>
        private var getEpisodesManager: NetworkManager<EpisodeModel>
        
        @Published private(set) var character: Content
        @Published private(set) var characterAvatar: UIImage?
        @Published private(set) var origin: OriginRequestModel?
        @Published private(set) var episodesModel: [EpisodeModel] = []
        @Published var data: [[Decodable]] = []
        private(set) var requestError: Error?
        
        init(
            character: Content,
            getOrigin: NetworkManager<OriginRequestModel>,
            getEpisodes: NetworkManager<EpisodeModel>
        ) {
            self.character = character
            self.getOriginManager = getOrigin
            self.getEpisodesManager = getEpisodes
            super.init()
            self.data.append([character])
        }
        
        @MainActor
        func getCharacterInfo(for character: Content) {
            loadTask?.cancel()
            loadTask = Task {
                do {
                   if !character.origin.url.isEmpty {
                       async let origin =  getOriginManager.getData(.getCharacterPlaceInfo(URL: character.origin.url))
                        
                        try await self.origin = origin
                        
                   } else {
                       let origin = OriginRequestModel(name: "None", type: "None")
                       self.origin = origin
                   }
                    
                    async let episodes: [EpisodeModel] = withThrowingTaskGroup(of: EpisodeModel.self) { group -> [EpisodeModel] in
                        
                        for url in character.episode {
                            group.addTask {
                                return try await self.getEpisodesManager.getData(.getEpisodesWithChaearacter(URL: url))
                            }
                        }
                        
                        var episodes: [EpisodeModel] = []
                        
                        for try await episode in group {
                            episodes.append(episode)
                        }
                        
                        return episodes
                    }
                    
                    try await self.episodesModel = episodes
                } catch {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
        
        @MainActor
        func getImage(for character: Content) {
            loadImageTask = Task { [weak self] in
                do {
                    let image = try await Self.imageLoader.loadImage(for: URL(string: character.image)!)
                    self?.characterAvatar = image
                } catch {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}
