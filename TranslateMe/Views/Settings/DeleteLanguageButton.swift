//
//  DeleteLanguageButton.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 18..
//

import SwiftUI

struct DeleteButtonView: View {
    
    private let cellViewModel: LanguagesCellViewModel
        
    init(cellViewModel: LanguagesCellViewModel) {
        self.cellViewModel = cellViewModel
    }
    
    var body: some View {
        Button(action: {
            if cellViewModel.language == .english {
                //TODO: - SHOW ERROR ALERT HERE, YOU CANT DELETE ENGLISH
            }
            TMLanguageModels.shared.deleteLanguage(language: cellViewModel.language) { success in
                if success {
                    cellViewModel.onTapHandler(cellViewModel.option)
                }
            }
        }) {
            HStack {
                let width = UIScreen.main.bounds.width / 11
                if let image = cellViewModel.image {
                    if cellViewModel.language != .english {
                        Image(uiImage: image)
                            .renderingMode(.template)
                            .foregroundColor(.primary)
                            .font(.title)
                            .frame(width: width, height: width)
                    } else {
                        Image(uiImage: image)
                            .frame(width: width, height: width)
                            .opacity(0)
                    }
                    
                }
            }
            .padding(.vertical)
            .foregroundColor(.primary)
            .cornerRadius(8)
        }
    }
}
