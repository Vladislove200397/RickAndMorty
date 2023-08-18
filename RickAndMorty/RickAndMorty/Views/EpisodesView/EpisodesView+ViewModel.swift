//
//  EpisodesView+ViewModel.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

extension EpisodeView {
    class ViewModel: BasicViewModel {
        @Published var episode: EpisodeModel
        
        init(episode: EpisodeModel) {
            self.episode = episode
        }
    }
}
