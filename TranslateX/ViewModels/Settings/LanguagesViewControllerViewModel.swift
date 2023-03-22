//
//  LanguagesViewControllerViewModel.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import MLKitTranslate
import SwiftUI

class LanguagesViewControllerViewModel: Hashable, Equatable, ObservableObject {
    @Published var downloadStates: [TranslateLanguage: Bool] = [:]
    @Published var downloadedCellViewModels: [LanguagesCellViewModel]
    @Published var notDownloadedCellViewModels: [LanguagesCellViewModel]
    @Published var filteredDownloadedCellViewModels: [LanguagesCellViewModel]
    @Published var filteredNotDownloadedCellViewModels: [LanguagesCellViewModel]
    public var searchText: String = ""
    
    init() {
        self.downloadedCellViewModels = []
        self.notDownloadedCellViewModels = []
        self.filteredDownloadedCellViewModels = []
        self.filteredNotDownloadedCellViewModels = []
        self.updateCellViewModels()
    }
    
    func updateDownloadState(for language: TranslateLanguage, isDownloading: Bool) {
        downloadStates[language] = isDownloading
    }
    
    public func updateCellViewModels() {
        self.downloadedCellViewModels = TXLanguageModels.shared.localModels.compactMap({
            return LanguagesCellViewModel(language: $0, option: .delete) { [weak self] option in
                self?.handleTap()
            }
        })
        self.notDownloadedCellViewModels = TXLanguages.shared.allTranslateLanguages.filter { !TXLanguageModels.shared.localModels.contains($0) }.compactMap({
            return LanguagesCellViewModel(language: $0, option: .download) { [weak self] option in
                self?.handleTap()
            }
        })
        sortCellViewModels()
        updateFilteredCellViewModels(with: searchText)
    }
    
    public func updateFilteredCellViewModels(with text: String) {
        sortCellViewModels()
        self.searchText = text
        if text.isEmpty {
            self.filteredDownloadedCellViewModels = downloadedCellViewModels
        } else {
            self.filteredDownloadedCellViewModels = downloadedCellViewModels.filter { $0.title.localizedCaseInsensitiveContains(text) }
        }
        
        if text.isEmpty {
            self.filteredNotDownloadedCellViewModels = notDownloadedCellViewModels
        } else {
            self.filteredNotDownloadedCellViewModels = notDownloadedCellViewModels.filter { $0.title.localizedCaseInsensitiveContains(text) }
        }
    }
    
    private func sortCellViewModels() {
        downloadedCellViewModels.sort { viewModel1, viewModel2 in
            return viewModel1.title < viewModel2.title
        }
        notDownloadedCellViewModels.sort { viewModel1, viewModel2 in
            return viewModel1.title < viewModel2.title
        }
    }
    
    static func == (lhs: LanguagesViewControllerViewModel, rhs: LanguagesViewControllerViewModel) -> Bool {
        return lhs.downloadedCellViewModels == rhs.downloadedCellViewModels &&
        lhs.notDownloadedCellViewModels == rhs.notDownloadedCellViewModels
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(downloadedCellViewModels)
        hasher.combine(notDownloadedCellViewModels)
    }
    
    private func handleTap() {
        guard Thread.current.isMainThread else {
            return
        }
        
        updateCellViewModels()
    }
}
