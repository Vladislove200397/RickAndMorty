//
//  UIIMageView+Extension.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import UIKit

extension UIImageView {
    private static let imageLoader = ImageLoaderService(cacheCountLimit: 500)
    
    @MainActor
    func setImage(by url: URL) async throws {
        let image = try await Self.imageLoader.loadImage(for: url)
        
        if !Task.isCancelled {
            self.image = image
        }
    }
}
