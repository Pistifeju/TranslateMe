//
//  LanguagesViewController.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 18..
//

import Foundation
import UIKit
import SwiftUI

class LanguagesViewController: UIViewController {
    
    // MARK: - Properties
    
    private var languagesSwiftUIView: UIHostingController<LanguagesView>?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func addSwiftUILanguagesView() {
        let languagesSwiftUIController = UIHostingController(rootView: LanguagesView())
        
        addChild(languagesSwiftUIController)
        languagesSwiftUIController.didMove(toParent: self)
        
        view.addSubview(languagesSwiftUIController.view)
        languagesSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            languagesSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            languagesSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            languagesSwiftUIController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            languagesSwiftUIController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
        
        self.languagesSwiftUIView = languagesSwiftUIController
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Languages"
        
        addSwiftUILanguagesView()
    }
    
    // MARK: - Selectors
}
