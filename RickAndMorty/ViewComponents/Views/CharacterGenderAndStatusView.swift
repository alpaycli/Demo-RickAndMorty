//
//  CharacterStatusView.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 20.10.25.
//

import PDFKit
import UIKit

class CharacterGenderAndStatusView: UIView {
      
   var imageName: String = "" {
      didSet {
         iconView.image = .init(named: imageName)
      }
   }
   var color: UIColor = .gray {
      didSet {
         backgroundColor = color
      }
   }

   var iconView = UIImageView()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   private func configure() {
      layer.cornerRadius = 20
      backgroundColor = .red
      
      addSubview(iconView)
      iconView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
         iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
         iconView.widthAnchor.constraint(equalToConstant: 32),
         iconView.heightAnchor.constraint(equalToConstant: 32)
      ])
   }
}
