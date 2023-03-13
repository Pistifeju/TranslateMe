//
//  MainTabBarViewControllerViewModel.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 13..
//

import Foundation
import UIKit

final class MainTabBarViewControllerViewModel {
    public func createNavigationControllers() -> [UIViewController] {
        let translateTextNav = templateNavigationController(image: UIImage(systemName: "textformat")!, rootViewController: TranslateTextViewController())
        
        let translateConversationNav = templateNavigationController(image: UIImage(systemName: "text.bubble")!, rootViewController: TranslateConversationViewController())
        
        let translateCameraNav = templateNavigationController(image: UIImage(systemName: "camera.viewfinder")!, rootViewController: TranslateCameraViewController())
        
        return [translateTextNav, translateConversationNav, translateCameraNav]
    }
    
    private func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .label
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.isHidden = false
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationItem.largeTitleDisplayMode = .always
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.label]
        nav.navigationBar.largeTitleTextAttributes = textAttributes
        nav.navigationBar.titleTextAttributes = textAttributes
        return nav
    }
}
