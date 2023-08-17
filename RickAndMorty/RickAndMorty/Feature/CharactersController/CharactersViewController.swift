//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import UIKit

class CharactersViewController: BasicController {
    
    // - Property
    private(set) var vm: ViewModel
    
    // - UI
    private lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(CharacterView.self, forCellWithReuseIdentifier: String(describing: CharacterView.self))
        return collection
    }()
    
    init(viewModel: ViewModel) {
        self.vm = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Characters"
        vm.getPaginationRequest(page: vm.currentPage)
    }
    
 //    - Configure
    override func makeLayout() {
        view.addSubview(collectionView)
    }

    override func makeConstraints() {
        NSLayoutConstraint.activate(
            [
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
    
    override func binding() {
        vm.$characters
            .sink {[weak self] characterList in
                self?.vm.isLoading = false
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: DataSource

extension CharactersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterView.id, for: indexPath)
        guard let characterCell = cell as? CharacterView else { return cell }
        
        characterCell.setViewModel(.init(content: vm.characters[indexPath.row]))
        
        if indexPath.row == vm.characters.count - 1, vm.currentPage != vm.totalPages {
            vm.fetchMoreData()
        }
        
        return characterCell
    }
}

// MARK: Delegate

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellCount = 2.0
        let inset = 16.0 / cellCount

        let width = collectionView.frame.width / cellCount - inset
        
        return CGSize(width: width, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
