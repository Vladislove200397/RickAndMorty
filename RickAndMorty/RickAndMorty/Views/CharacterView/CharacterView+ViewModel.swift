//
//  CharacterView+ViewModel.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

extension CharacterView {
    class ViewModel: BasicViewModel {
        @Published var content: Content
        
        init(content: Content) {
            self.content = content
        }
    }
}
