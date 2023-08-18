//
//  InfoView.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import UIKit
import Combine

class InfoView: UITableViewCell {
    // - Static
    static var id = String(describing: InfoView.self)
    
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
    
    private lazy var speciesHStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
        return $0
    }(UIStackView())
    
    private lazy var typeHStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
        return $0
    }(UIStackView())
    
    private lazy var genderHStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
        return $0
    }(UIStackView())
    
    private lazy var speciesLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .grayTextColor
        $0.textAlignment = .left
        $0.text = "Species:"
        $0.font = .custom(size: 16, weight: .medium)
        return $0
    }(UILabel())
    
    private lazy var typeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .grayTextColor
        $0.textAlignment = .left
        $0.text = "Type:"
        $0.font = .custom(size: 16, weight: .medium)
        return $0
    }(UILabel())
    
    private lazy var genderLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .grayTextColor
        $0.textAlignment = .left
        $0.text = "Gender:"
        $0.font = .custom(size: 16, weight: .medium)
        return $0
    }(UILabel())
    
    private lazy var speciesValueLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.textAlignment = .right
        $0.font = .custom(size: 16, weight: .medium)
        return $0
    }(UILabel())
    
    private lazy var typeValueLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.textAlignment = .right
        $0.font = .custom(size: 16, weight: .medium)
        return $0
    }(UILabel())
    
    private lazy var genderValueLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.textAlignment = .right
        $0.font = .custom(size: 16, weight: .medium)
        return $0
    }(UILabel())
    
    // - Configure
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
    
    private func makeLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(VStack)
        
        speciesHStack.addArrangedSubview(speciesLabel)
        speciesHStack.addArrangedSubview(speciesValueLabel)
        
        typeHStack.addArrangedSubview(typeLabel)
        typeHStack.addArrangedSubview(typeValueLabel)
        
        genderHStack.addArrangedSubview(genderLabel)
        genderHStack.addArrangedSubview(genderValueLabel)
        
        VStack.addArrangedSubview(speciesHStack)
        VStack.addArrangedSubview(typeHStack)
        VStack.addArrangedSubview(genderHStack)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            //containerView
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            //VStack
            VStack.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 16),
            VStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 16),
            VStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -16),
            VStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -16),
        ])
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.vm = vm
        
        vm.$content
            .sink {[weak self] content in
                guard let self else { return }
                if !content.gender.isEmpty {
                    self.genderValueLabel.text = content.gender
                } else {
                    self.genderValueLabel.text = "None"
                }
                
                if !content.type.isEmpty {
                    self.typeValueLabel.text = content.species
                } else {
                    self.typeValueLabel.text = "None"
                }
                
                if !content.species.isEmpty {
                    self.speciesValueLabel.text = content.species
                } else {
                    self.speciesValueLabel.text = "None"
                }
            }
            .store(in: &cancellables)
    }
}
