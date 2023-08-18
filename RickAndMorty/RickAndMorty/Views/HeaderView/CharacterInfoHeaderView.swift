//
//  HeaderView.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import UIKit
import Combine

class CharacterInfoHeaderView: UIView {
    // - Property
    var cancellables: Set<AnyCancellable> = []
    
    // - UI
    private lazy var label: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.font = .custom(size: 17, weight: .semibold)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        makeLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Configure
    private func makeLayout() {
        addSubview(label)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setViewModel(_ vm: ViewModel) {
        vm.$text
            .sink(receiveValue: {[weak self] in self?.label.text = $0 })
            .store(in: &cancellables)
    }
}
