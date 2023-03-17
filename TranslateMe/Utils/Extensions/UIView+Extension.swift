//
//  UIView+Extension.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 17..
//

import Foundation
import UIKit

extension UIView {
    func addBasicShadow() {
        layer.shadowColor = UIColor.secondaryLabel.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
    }
    
    func simpleTapAnimation() {
        UIView.animate(withDuration: 0.07, animations: {
            self.alpha = 0.5
        }) { (completed) in
            UIView.animate(withDuration: 0.07) {
                self.alpha = 1.0
            }
        }
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
