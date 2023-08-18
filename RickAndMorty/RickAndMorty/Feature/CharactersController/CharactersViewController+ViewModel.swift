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
        @Published private(set) var characters: [Content] = []
        private(set) var requestError: Error?
        private(set) var currentPage: Int = 1
        private(set) var totalPages: Int = 0
        var isLoading: Bool = false
        
        init(getDataService: NetworkManager<CharactersListModel>) {
            self.getDataService = getDataService
        }
        
        @MainActor
        func getPaginationRequest(page: Int? = 1) {
            loadTask?.cancel()
            loadTask = Task {
                do {
                    let charactersPaginationData = try await getDataService.getData(.getCharactersPagination(page: currentPage))
                    characterList = charactersPaginationData
                    characters += charactersPaginationData.results
                    totalPages = charactersPaginationData.info.pages
                } catch {
                    requestError = error
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
        
        @MainActor func fetchMoreData() {
            if !isLoading {
                currentPage += 1
                getPaginationRequest(page: currentPage)
                isLoading = true
            }
        }
    }
}
