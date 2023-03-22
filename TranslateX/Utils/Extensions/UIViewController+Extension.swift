//
//  UIViewController+Extension.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 20..
//

import Foundation
import UIKit

extension UIViewController {
    public func showLanguagePickerView(pickerView: UIPickerView, alert: UIAlertController) {
        let vc = UIViewController()
        let height = UIScreen.main.bounds.height / 2
        let width = UIScreen.main.bounds.width - 16
        vc.preferredContentSize = CGSize(width: width, height: height)
        vc.view.addSubview(pickerView)
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.topAnchor.constraint(equalTo: vc.view.topAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
        alert.setValue(vc, forKey: "contentViewController")
        navigationController?.present(alert, animated: true)
    }
}
