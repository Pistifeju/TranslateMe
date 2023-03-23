//
//  PhotoOutputView.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 23..
//

import SwiftUI

struct PhotoOutputView: View {
    private let viewModel: TranslatePhotoOutputViewViewModel
    
    init(viewModel: TranslatePhotoOutputViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack {
                UITextViewWrapper(text: viewModel.languagePair.sourceText, textColor: .label)
                    .frame(height: viewModel.sourceTextHeight)

                Divider()
                
                UITextViewWrapper(text: viewModel.languagePair.targetText, textColor: .systemBlue)
                    .frame(height: viewModel.targetTextHeight)
            }
            .padding()
        }
    }
}

struct PhotoOutputView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoOutputView(viewModel: TranslatePhotoOutputViewViewModel(languagePair: TXLanguagePair(sourceLanguage: .english, targetLanguage: .hungarian)))
    }
}
