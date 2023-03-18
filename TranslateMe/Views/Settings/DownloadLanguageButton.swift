//
//  DownloadLanguageButton.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import SwiftUI

struct DownloadButtonView: View {
    @State private var isDownloading = false
    
    private let cellViewModel: LanguagesCellViewModel
    
    init(cellViewModel: LanguagesCellViewModel) {
        self.cellViewModel = cellViewModel
    }
    
    var body: some View {
        Button(action: {
            isDownloading = true
            TMLanguageModels.shared.downloadLanguageIfNeeded(sourceLanguage: .english, targetLanguage: cellViewModel.language) { error in
                if let error {
                    // TODO: Show error alert here.
                }
                
                cellViewModel.onTapHandler(cellViewModel.option)
                isDownloading = false
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
