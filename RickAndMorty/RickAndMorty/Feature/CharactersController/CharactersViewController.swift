//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import UIKit

class CharactersViewController: BasicController, UINavigationBarDelegate {
    
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
    
    // - Lifecycle
    init(viewModel: ViewModel) {
        self.vm = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.getPaginationRequest(page: vm.currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Characters"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = " "
    }
    
    // - Configure
    override func makeLayout() {
        view.safeAreaLayoutGuide.owningView?.addSubview(collectionView)
    }

    override func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        let width = (collectionView.frame.width / 2) - 32
        let height = (collectionView.frame.height / 3.7) - 32

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AboutCharacterController(viewModel:
                .init(
                    character: vm.characters[indexPath.row] ,
                    getOrigin: NetworkManager<OriginRequestModel>(),
                    getEpisodes: NetworkManager<EpisodeModel>()
                )
        )
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
    }
}
