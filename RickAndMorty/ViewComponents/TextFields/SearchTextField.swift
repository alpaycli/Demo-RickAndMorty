//
//  SearchTextField.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 23.10.25.
//

import UIKit

class SearchTextField: UITextField {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = UIColor(hexString: "#6B007C")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let padding: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        backgroundColor = UIColor(hexString: "#AF99BB")
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        textColor = UIColor(hexString: "#6B007C")
        font = UIFont.systemFont(ofSize: 17, weight: .medium)
        attributedPlaceholder = NSAttributedString(
            string: "Search...",
            attributes: [
                .foregroundColor: UIColor(hexString: "#8D4D9C"),
                .font: UIFont.systemFont(ofSize: 22, weight: .medium)
            ]
        )
        
        leftView = iconContainerView()
        leftViewMode = .always
    }
    
    private func iconContainerView() -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
        iconImageView.frame = CGRect(x: padding, y: 0, width: 24, height: 24)
        iconImageView.center.y = container.center.y
        container.addSubview(iconImageView)
        return container
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 8))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
