//
//  DownloadLanguageButton.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import SwiftUI

struct DownloadButtonView: View {
    var isDownloading: Bool {
        controllerViewModel.downloadStates[cellViewModel.language] ?? false
    }

    @ObservedObject private var controllerViewModel: LanguagesViewControllerViewModel
    
    private let cellViewModel: LanguagesCellViewModel
    
    init(cellViewModel: LanguagesCellViewModel, controllerViewModel: LanguagesViewControllerViewModel) {
        self.cellViewModel = cellViewModel
        self.controllerViewModel = controllerViewModel
    }

    
    var body: some View {
        Button(action: {
            controllerViewModel.updateDownloadState(for: cellViewModel.language, isDownloading: true)
            TXLanguageModels.shared.downloadLanguageIfNeeded(sourceLanguage: .english, targetLanguage: cellViewModel.language) { error in
                if let error {
                    // TODO: Show error alert here.
                }
                
                cellViewModel.onTapHandler(cellViewModel.option)
                controllerViewModel.updateDownloadState(for: cellViewModel.language, isDownloading: false)
            }
        }) {
            HStack {
                let width = UIScreen.main.bounds.width / 11
                if isDownloading {
                    ProgressView()
                        .pickerStyle(.menu)
                        .frame(width: width, height: width)
                } else {
                    if let image = cellViewModel.image {
                        Image(uiImage: image)
                            .renderingMode(.template)
                            .foregroundColor(.primary)
                            .font(.title)
                            .frame(width: width, height: width)
                    }
                }
            }
            .padding(.vertical)
            .foregroundColor(.primary)
            .cornerRadius(8)
        }
        .disabled(isDownloading)
    }
}
