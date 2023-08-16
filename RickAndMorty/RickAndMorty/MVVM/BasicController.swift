//
//  BasicController.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 16.08.23.
//

import UIKit
import Combine

class BasicController: UIViewController {
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        makeLayout()
        makeConstraints()
    }
    
    func makeLayout() {}
    func makeConstraints() {}
}