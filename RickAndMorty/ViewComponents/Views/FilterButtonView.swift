//
//  FilterButtonView.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 21.10.25.
//

import UIKit
import SwiftUI

final class FilterButtonView: UIView {
   
   private let button = UIButton(type: .system)
   private let clearButton = UIButton(type: .system)
   
   var onClear: (() -> Void)?
   
   init(title: String, menu: UIMenu) {
      super.init(frame: .zero)
      setupUI(title: title, menu: menu)
   }
   
   required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
   
   private func setupUI(title: String, menu: UIMenu) {
      var config = UIButton.Configuration.filled()
      config.cornerStyle = .capsule
      config.baseBackgroundColor = .init(hexString: "#D9D9D9")
      config.baseForegroundColor = .init(hexString: "#A26CAB")
      
      var attrTitle = AttributedString(title)
      attrTitle.font = .systemFont(ofSize: 14, weight: .medium)
      config.attributedTitle = attrTitle
      
      config.image = UIImage(systemName: "chevron.down")
      config.imagePlacement = .trailing
      config.imagePadding = 4
      
      button.configuration = config
      button.menu = menu
      button.showsMenuAsPrimaryAction = true
      
      clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
      clearButton.tintColor = .systemGray3
      clearButton.isHidden = true
      clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
      
      let stack = UIStackView(arrangedSubviews: [button, clearButton])
      stack.axis = .horizontal
      stack.alignment = .center
      stack.spacing = 4
      
      addSubview(stack)
      stack.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         stack.leadingAnchor.constraint(equalTo: leadingAnchor),
         stack.trailingAnchor.constraint(equalTo: trailingAnchor),
         stack.topAnchor.constraint(equalTo: topAnchor),
         stack.bottomAnchor.constraint(equalTo: bottomAnchor),
         
         clearButton.widthAnchor.constraint(equalToConstant: 22),
         clearButton.heightAnchor.constraint(equalTo: clearButton.widthAnchor)
      ])
   }
   
   @objc private func clearTapped() {
      print("Salam")
      onClear?()
   }
   
   func updateFilter(title: String?, defaultTitle: String) {
      guard var config = button.configuration else { return }
      
      if let title = title {
         var attrTitle = AttributedString(title)
         attrTitle.font = .systemFont(ofSize: 15, weight: .medium)
         config.attributedTitle = attrTitle
         config.image = nil
         clearButton.isHidden = false
      } else {
         var attrTitle = AttributedString(defaultTitle)
         attrTitle.font = .systemFont(ofSize: 15, weight: .medium)
         config.attributedTitle = attrTitle
         config.image = UIImage(systemName: "chevron.down")
         clearButton.isHidden = true
      }
      
      button.configuration = config
   }
}
