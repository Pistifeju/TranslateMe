//
//  UILabel+Extension.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 21..
//

import Foundation
import UIKit

extension UILabel {
    func calculateLabelHeight(with width: CGFloat) -> CGSize {
        let font = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        
        let text = text ?? ""
        let size = text.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     attributes: [.font: font],
                                     context: nil).size
        
        let height = ceil(size.height)
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
