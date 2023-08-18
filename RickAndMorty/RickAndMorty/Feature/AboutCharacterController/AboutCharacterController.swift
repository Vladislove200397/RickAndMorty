//
//  AboutCharacterController.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import UIKit

class AboutCharacterController: BasicController {
    
    // - Property
    private let minConstraintConstant: CGFloat = 0
    private var maxConstraintConstant: CGFloat = 0
    private var vm: ViewModel
    
    // - Flag
    var isFirstLayout: Bool = true
    
    // - UI
    lazy private var activityIndicatorView: UIActivityIndicatorView = {
        $0.hidesWhenStopped = true
        $0.style = .large
        $0.color = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIActivityIndicatorView())
    
    private lazy var topView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var characterImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
        return $0
    }(UIImageView())
    
    private lazy var characterNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .custom(size: 22, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var characterStatusLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .custom(size: 16, weight: .medium)
        $0.textColor = .greenTextColor
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .background
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.register(OriginView.self, forCellReuseIdentifier: OriginView.id)
        $0.register(EpisodeView.self, forCellReuseIdentifier: EpisodeView.id)
        $0.register(InfoView.self, forCellReuseIdentifier: InfoView.id)
        $0.allowsSelection = false
        return $0
    }(UITableView())
    
    private var animatedConstraint: NSLayoutConstraint?

    private var previousContentOffsetY: CGFloat = 0
    
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
        navigationItem.largeTitleDisplayMode = .never
        activityIndicatorView.startAnimating()
        vm.getCharacterInfo(for: vm.character)
        vm.getImage(for: vm.character)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLayout {
            maxConstraintConstant = topView.frame.size.height
            animatedConstraint?.constant = maxConstraintConstant
            isFirstLayout = false
        }
    }
    
    // - Configure
    override func makeLayout() {
        navigationItem.backButtonDisplayMode = .minimal
        view.addSubview(topView)
        topView.addSubview(characterImageView)
        topView.addSubview(characterNameLabel)
        topView.addSubview(characterStatusLabel)
        
        view.addSubview(tableView)
        view.addSubview(activityIndicatorView)
    }
    
    override func makeConstraints() {
        
        animatedConstraint = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: maxConstraintConstant)
        
        NSLayoutConstraint.activate([
            //topView
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            //characterImageView
            characterImageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 16),
            characterImageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: 150),
            characterImageView.widthAnchor.constraint(equalToConstant: 150),
            
            //characterNameLabel
            characterNameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 24),
            characterNameLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            
            //characterStatusLabel
            characterStatusLabel.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 8),
            characterStatusLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            characterStatusLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -20),
            
            //tableView
            animatedConstraint!,
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            //activityIndicator
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func binding() {
        vm.$character
            .sink {[weak self] character in
                guard let self else { return }
                self.characterNameLabel.text = character.name
                self.characterStatusLabel.text = character.status
            }
            .store(in: &cancellables)
        
        vm.$episodesModel
            .dropFirst()
            .sink {[weak self] episodes in
                guard let self else { return }
                self.vm.data.append(episodes)
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        vm.$data
            .sink(receiveValue: {[weak self] _ in self?.tableView.reloadData()})
            .store(in: &cancellables)
        
        vm.$origin
            .dropFirst()
            .sink(receiveValue: {[weak self] origin in
                guard let self else { return }
                self.vm.data.append([origin])
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            })
            .store(in: &cancellables)
        
        vm.$characterAvatar
            .sink {[weak self] in self?.characterImageView.image = $0 }
            .store(in: &cancellables)
        
    }
}

// MARK: DataSource

extension AboutCharacterController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        vm.data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.data[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CharacterInfoHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let element = vm.data[section]
        
        switch element {
            case _ as [Content]:
                header.setViewModel(.init(text: "Info"))
                return header
                
            case _ as [OriginRequestModel]:
                header.setViewModel(.init(text: "Origin"))
                return header
                
            case _ as [EpisodeModel]:
                header.setViewModel(.init(text: "Episodes"))
                return header
            default: return UIView()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = vm.data[indexPath.section]
        
        switch element {
            case let element as [Content]:
                let cell = tableView.dequeueReusableCell(withIdentifier: InfoView.id, for: indexPath)
                (cell as? InfoView)?.setViewModel(.init(character: element[indexPath.row]))
                
            case let element as [OriginRequestModel]:
                let originCell = tableView.dequeueReusableCell(withIdentifier: OriginView.id, for: indexPath)
                (originCell as? OriginView)?.setViewModel(.init(origin: element[indexPath.row]))
                
            case let element as [EpisodeModel]:
                let episodeCell = tableView.dequeueReusableCell(withIdentifier: EpisodeView.id, for: indexPath)
                (episodeCell as? EpisodeView)?.setViewModel(.init(episode: element[indexPath.row]))
                
            default: break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return 140
            case 1:
                return 80
            default: return 95
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return UITableView.automaticDimension
      }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
            return 70
        }
}

// MARK: Delegate

extension AboutCharacterController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffsetY = scrollView.contentOffset.y
        let scrollDiff = currentContentOffsetY - previousContentOffsetY

        let bounceBorderContentOffsetY = -scrollView.contentInset.top

        let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
        let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY

        let currentConstraintConstant = animatedConstraint!.constant
        var newConstraintConstant = currentConstraintConstant

        if contentMovesUp {
            
            newConstraintConstant = max(currentConstraintConstant - scrollDiff, minConstraintConstant)
            if newConstraintConstant == 0 {
                title = vm.character.name
            }
        } else if contentMovesDown {
            title = ""
            newConstraintConstant = min(currentConstraintConstant - scrollDiff, maxConstraintConstant)
        }

        if newConstraintConstant != currentConstraintConstant {
            animatedConstraint?.constant = newConstraintConstant
            scrollView.contentOffset.y = previousContentOffsetY
        }
        
        previousContentOffsetY = scrollView.contentOffset.y
        
        let topViewAnimationScale = max(1.0,min(2.0 - newConstraintConstant / maxConstraintConstant, 2))
        let topViewAlphaScale = min(max(1.0 - newConstraintConstant / (maxConstraintConstant - 20.0), 0.0), 1.0)
        
        self.topView.transform = CGAffineTransform(scaleX: topViewAnimationScale, y: topViewAnimationScale)
        self.topView.alpha = 1 - topViewAlphaScale
    }
}
