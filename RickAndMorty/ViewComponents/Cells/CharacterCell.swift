//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 20.10.25.
//

import SwiftUI
import UIKit

final class CharacterCell: UICollectionViewCell {
   static let reuseId = "CharacterCell"
   private let avatarImage = GFAvatarImageView(frame: .zero)
   private let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 22)
   private let secondTitleLabel = GFTitleLabel(textAlignment: .center, fontSize: 18)
   private let genderAndStatusView = CharacterGenderAndStatusView()
   private let bookmarkStatusView = UIImageView()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
//      layer.borderWidth = 0.5
//      layer.borderColor = UIColor.systemGray3.cgColor
      layer.cornerRadius = 5
      configureImageAndTitle()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(character: Character) {
      switch character.status {
         case "Alive": genderAndStatusView.color = .green
         case "Dead": genderAndStatusView.color = .red
         default:
            // ❓ Unknown"
            genderAndStatusView.color = .gray
      }
      
      switch character.gender {
         case "Male": genderAndStatusView.imageName = GenderImage.male.rawValue
         case "Female": genderAndStatusView.imageName = GenderImage.female.rawValue
         case "Genderless": genderAndStatusView.imageName = GenderImage.genderless.rawValue
         default: genderAndStatusView.imageName = GenderImage.unknown.rawValue
      }
      
      if let imageURL = character.image {
         avatarImage.downloadImage(fromURL: imageURL.absoluteString)
      }
      secondTitleLabel.text = character.species
      titleLabel.text = character.name
      
      changeBookmarkStatus(for: character)
   }
   
   func changeBookmarkStatus(for character: Character) {
      bookmarkStatusView.image = character.isBookmarked ? .bookmarkIconGreen : nil
   }
   
   private func configureImageAndTitle() {
      addSubview(avatarImage)
      addSubview(titleLabel)
      addSubview(secondTitleLabel)
      addSubview(genderAndStatusView)
      addSubview(bookmarkStatusView)
      
      let padding: CGFloat = 5
      translatesAutoresizingMaskIntoConstraints = false
      
      genderAndStatusView.translatesAutoresizingMaskIntoConstraints = false
      bookmarkStatusView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor),
         avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         avatarImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor),
         
         titleLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 12),
         titleLabel.centerXAnchor.constraint(equalTo: avatarImage.centerXAnchor),
         titleLabel.heightAnchor.constraint(equalToConstant: 20),
         
         secondTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
         secondTitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
         secondTitleLabel.heightAnchor.constraint(equalToConstant: 20),
         
         genderAndStatusView.topAnchor.constraint(equalTo: avatarImage.topAnchor, constant: 10),
         genderAndStatusView.trailingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: -5),
         genderAndStatusView.widthAnchor.constraint(equalToConstant: 44),
         genderAndStatusView.heightAnchor.constraint(equalToConstant: 44),
         
         bookmarkStatusView.topAnchor.constraint(equalTo: avatarImage.topAnchor, constant: 13),
         bookmarkStatusView.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor, constant: 5),
         bookmarkStatusView.widthAnchor.constraint(equalToConstant: 28),
         bookmarkStatusView.heightAnchor.constraint(equalToConstant: 34),
      ])
   }
}
