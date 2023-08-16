//
//  AppDelegate.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 16.08.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initNavbar()
        return true
    }

    private func initNavbar() {
        if #available(iOS 15.0, *) {
            let attrs = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.custom(size: 28, weight: .bold)
            ]
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = .background
            navigationBarAppearance.titleTextAttributes = attrs
            navigationBarAppearance.largeTitleTextAttributes = attrs
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
}

