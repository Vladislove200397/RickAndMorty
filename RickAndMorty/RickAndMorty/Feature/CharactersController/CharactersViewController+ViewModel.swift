//
//  CharactersViewController+ViewModel.swift
//  RickAndMorty
//
//  Created by Vlad Kulakovsky  on 17.08.23.
//

import Foundation

extension CharactersViewController {
    class ViewModel: BasicViewModel {
        private var loadTask: Task<Void, Never>?
        private var getDataService: NetworkManager<CharactersListModel>
        @Published private(set) var characterList: CharactersListModel?
        @Published private(set) var requestError: Error?
        
        init(getDataService: NetworkManager<CharactersListModel>) {
            self.getDataService = getDataService
        }
        
        @MainActor
        func getPaginationRequest(page: Int? = 1) {
            loadTask?.cancel()
            loadTask = Task {
                do {
                    let charactersPaginationData = try await getDataService.getData(.getCharactersPagination(page: 1))
                    characterList = charactersPaginationData
                } catch {
                    requestError = error
                }
            }
        }
    }
}
