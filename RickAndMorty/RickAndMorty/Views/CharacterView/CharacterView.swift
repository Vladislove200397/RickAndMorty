//
//  CharacterView.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import UIKit
import Combine

class CharacterView: UICollectionViewCell {
    // - Static
    static let id = String(describing: CharacterView.self)
    
    // - Property
    private var loadImageTask: Task<Void, Never>?
    var cancellables: Set<AnyCancellable> = []
    private(set) var vm: ViewModel?
    
    // - UI
    lazy private var imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())
    
    lazy private var nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .custom(size: 17, weight: .bold)
        $0.textColor = .white
        $0.adjustsFontSizeToFitWidth = true
        $0.numberOfLines = 1
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    lazy private var activityIndicatorView: UIActivityIndicatorView = {
        $0.hidesWhenStopped = true
        $0.style = .medium
        $0.color = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIActivityIndicatorView())
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .cellBackground
        contentView.layer.cornerRadius = 16
        makeLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Configure
    func makeLayout() {
        contentView.addSubview(imageView)
        imageView.addSubview(activityIndicatorView)
        contentView.addSubview(nameLabel)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            //imageView
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 140),
            imageView.widthAnchor.constraint(equalToConstant: 140),
            
            //nameLabel
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            //spinner
            activityIndicatorView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        
        vm.$content
            .sink {[weak self] content in
                guard let self else { return }
                self.nameLabel.text = content.name
                self.configureImage(for: URL(string: content.image)!)
            }
            .store(in: &cancellables)
    }
    
    private func configureImage(for url: URL) {
        loadImageTask?.cancel()
        
        loadImageTask = Task { [weak self] in
            self?.imageView.image = nil
            self?.activityIndicatorView.startAnimating()
            
            do {
                try await self?.imageView.setImage(by: url)
                self?.imageView.contentMode = .scaleAspectFill
            } catch {
                self?.imageView.contentMode = .center
            }
            
            self?.activityIndicatorView.stopAnimating()
        }
    }
}
