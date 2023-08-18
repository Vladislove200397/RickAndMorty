//
//  InfoView+ViewModel.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

extension InfoView {
    class ViewModel: BasicViewModel {
        @Published var content: Content
        
        init(character: Content) {
            self.content = character
            super.init()
        }
    }
}
