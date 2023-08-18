//
//  HeaderView+ViewModel.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

extension CharacterInfoHeaderView {
    class ViewModel: BasicViewModel {
       @Published var text: String
        
        init(text: String) {
            self.text = text
        }
    }
}
