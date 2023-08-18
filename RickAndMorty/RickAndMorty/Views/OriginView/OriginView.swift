//
//  OriginView.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import UIKit
import Combine

class OriginView: UITableViewCell {
    // - Static
    static var id = String(describing: OriginView.self)
    
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
    
    private lazy var imageContainerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .imageBackground
        $0.layer.cornerRadius = 10
        return $0
    }(UIView())
    
    private lazy var planetImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "planet")!
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var VStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 8
        return $0
    }(UIStackView())
    
    private lazy var originNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = .custom(size: 17, weight: .semibold)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var originTypeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .greenTextColor
        $0.font = .custom(size: 13, weight: .medium)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .background
        backgroundColor = .clear
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
        containerView.addSubview(imageContainerView)
        imageContainerView.addSubview(planetImageView)
        containerView.addSubview(VStack)
        VStack.addArrangedSubview(originNameLabel)
        VStack.addArrangedSubview(originTypeLabel)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            //container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            //imageContainerView
            imageContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            imageContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            imageContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            imageContainerView.trailingAnchor.constraint(equalTo: VStack.leadingAnchor, constant: -8),
            imageContainerView.heightAnchor.constraint(equalToConstant: 65),
            imageContainerView.widthAnchor.constraint(equalToConstant: 65),
            
            //imageView
            planetImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            planetImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            planetImageView.heightAnchor.constraint(equalToConstant: 25),
            planetImageView.widthAnchor.constraint(equalToConstant: 25),
            
            //VStack
            VStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            VStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            VStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func setViewModel(_ vm: ViewModel) {
        vm.$origin
            .sink { [weak self] originModel in
                guard let self else { return }
                
                if !originModel.name.isEmpty {
                    self.originNameLabel.text = originModel.name
                } else {
                    self.originNameLabel.text = "None"
                }
                
                if !originModel.type.isEmpty {
                    self.originTypeLabel.text = originModel.type
                } else {
                    self.originTypeLabel.text = "None"
                }

            }
            .store(in: &cancellables)
    }
}
