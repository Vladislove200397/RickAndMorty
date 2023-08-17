//
//  BasicViewModel.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 16.08.23.
//

import Foundation
import Combine
import UIKit

class BasicViewModel {
    var cancellables: Set<AnyCancellable> = []
    
    func showAlert(title: String, message: String, okHandler: @escaping ()->()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okHandler()
        }
        alertController.addAction(okAction)
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController?.present(alertController, animated: true)
    }
}
