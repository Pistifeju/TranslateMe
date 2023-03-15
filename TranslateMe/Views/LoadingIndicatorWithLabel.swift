//
//  LoadingIndicatorWithLabel.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 15..
//

import Foundation
import UIKit

class ActivityLabelIndicatorView: UIView {
    
    // MARK: - Properties
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(title: String) {
        self.titleLabel.text = title
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        // added 32 because of:
        // 8 activityIndicator.leadingAnchor multiplier 1
        // 8 titleLabel trailingAnchor padding
        // 16 titleLabel.leadingAnchor multiplier 2
        let width = activityIndicator.bounds.width + titleLabel.bounds.width + 32
        let height = activityIndicator.bounds.height + 8 // Added +8 for the top and bottom 4-4 padding.
        return CGSize(width: width, height: height * 2)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        isHidden = true
        backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        layer.cornerRadius = 8
        
        addSubview(activityIndicator)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: activityIndicator.trailingAnchor, multiplier: 2),
            titleLabel.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor),
        ])
    }
    
    public func startAnimating() {
        activityIndicator.startAnimating()
        isHidden = false
    }
    
    public func stopAnimating() {
        activityIndicator.startAnimating()
        isHidden = true
    }
    
    // MARK: - Selectors
    
}
