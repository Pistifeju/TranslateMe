//
//  UITextViewWrapper.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 23..
//

import SwiftUI

struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    var text: String
    var textColor: UIColor
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = textColor
        textView.text = text
        textView.isEditable = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = UIColor.secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
