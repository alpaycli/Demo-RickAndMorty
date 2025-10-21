//
//  CharacterDetailVC.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 21.10.25.
//

import UIKit

class CharacterDetailVC: UIViewController {
   
   private let titleLabel = UILabel()
   private let imageView = GFAvatarImageView(frame: .zero)
   
   private let genderLabel      = GFTitleLabel()
   private let statusLabel      = GFTitleLabel()
   private let speciesLabel     = GFTitleLabel()
   private let typeLabel        = GFTitleLabel()
   private let originLabel      = GFTitleLabel()
   private let detailsStackView = UIStackView()
   
   private let character: Character
   init(character: Character) {
      self.character = character
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configureTitleLabel()
      configureImageView()
      configureStackView()
   }
   
   private func configureStackView() {
      view.addSubview(detailsStackView)
      
      detailsStackView.addArrangedSubview(genderLabel)
      detailsStackView.addArrangedSubview(statusLabel)
      detailsStackView.addArrangedSubview(speciesLabel)
      detailsStackView.addArrangedSubview(typeLabel)
      detailsStackView.addArrangedSubview(originLabel)
      
      detailsStackView.axis = .vertical
      detailsStackView.spacing = 10
      detailsStackView.distribution = .fillEqually
      
      detailsStackView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         detailsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
         detailsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         detailsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      ])
      
      genderLabel.text = NSLocalizedString("Gender", comment: "") + ": \(character.gender)"
      statusLabel.text = NSLocalizedString("Species", comment: "") + ": \(character.status)"
      speciesLabel.text = NSLocalizedString("Species", comment: "") + ": \(character.species)"
      typeLabel.text = NSLocalizedString("Type", comment: "") + ": \(character.type)"
      originLabel.text = NSLocalizedString("Origin", comment: "") + ": \(character.origin.name)"
   }
   
   private func configureTitleLabel() {
      view.addSubview(titleLabel)
      
      titleLabel.text = character.name
      titleLabel.textAlignment = .center
      titleLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
//      titleLabel.adjustsFontSizeToFitWidth = true
      titleLabel.minimumScaleFactor = 0.9
      titleLabel.lineBreakMode = .byTruncatingTail
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         titleLabel.heightAnchor.constraint(equalToConstant: 44)
      ])
   }
   
   private func configureImageView() {
      view.addSubview(imageView)
      if let imageUrlString = character.image?.absoluteString {
         imageView.downloadImage(fromURL: imageUrlString)
      }
      
      imageView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
         imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         imageView.heightAnchor.constraint(equalToConstant: 330)
      ])
   }
}
