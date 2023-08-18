//
//  EpisodeView.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import UIKit
import Combine

class EpisodeView: UITableViewCell {
    // - Static
    static var id = String(describing: EpisodeView.self)
    
    // - Property
    private(set) var vm: ViewModel?
    var cancellables: Set<AnyCancellable> = []
    
    // - UI
    private lazy var containerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .cellBackground
        $0.layer.cornerRadius = 16
        return $0
    }(UIView())
    
    private lazy var VStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 16
        return $0
    }(UIStackView())
    
    private lazy var HStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private lazy var episodeNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = .custom(size: 17, weight: .semibold)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var episodeNumberLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .greenTextColor
        $0.font = .custom(size: 13, weight: .medium)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var episodeDateLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .grayTextColor
        $0.font = .custom(size: 12, weight: .medium)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .background
        selectionStyle = .none
        makeLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Configure
    private func makeLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(VStack)
        
        VStack.addArrangedSubview(episodeNameLabel)
        VStack.addArrangedSubview(HStack)
        
        HStack.addArrangedSubview(episodeNumberLabel)
        HStack.addArrangedSubview(episodeDateLabel)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            //containerView
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            //VStack
            VStack.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 16),
            VStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            VStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            VStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
    }
    
    func setViewModel(_ vm: ViewModel) {
        vm.$episode
            .sink { [weak self] episode in
                let component = episode.episode.components(separatedBy: CharacterSet.decimalDigits.inverted)
                let list = component.filter({$0 != ""})
                if let season = Int(list.first ?? ""),
                   let episode = Int(list.last ?? "") {
                    self?.episodeNumberLabel.text = "Episode: \(episode), Season: \(season)"
                   }
                self?.episodeDateLabel.text = episode.air_date
                self?.episodeNameLabel.text = episode.name
                
            }
            .store(in: &cancellables)
    }
}
