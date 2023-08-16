//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import UIKit

class CharactersViewController: BasicController {
    
    // - UI
    private lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
//        collection.dataSource = self
//        collection.delegate = self
        
        return collection
    }()
    
    init(viewModel: ViewModel) {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Characters"
    }
    
 //    - Configure
    override func makeLayout() {
        view.addSubview(collectionView)
    }

    override func makeConstraints() {
        NSLayoutConstraint.activate(
            [
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}

// MARK: DataSource

//extension CharactersViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    
//    }
//}

// MARK: Delegate

extension CharactersViewController: UICollectionViewDelegate {
    
}
