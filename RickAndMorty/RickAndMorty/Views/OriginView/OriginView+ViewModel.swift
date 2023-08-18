//
//  OriginView+ViewModel.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

extension OriginView {
    class ViewModel: BasicViewModel {
        @Published var origin: OriginRequestModel
        
        init(origin: OriginRequestModel) {
            self.origin = origin
        }
    }
}
