//
//  CharacterDetailVC.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 21.10.25.
//

import UIKit

final class CharacterDetailVC: UIViewController {
   
   private let bookmarkManager: BookmarkManagable
   
   private let scrollView = UIScrollView()
   private let contentView = UIView()
   
   private let bookmarkButton = UIButton(type: .system)
   private let backButton = UIButton(type: .system)
   
   private let titleLabel = UILabel()
   private let imageView = GFAvatarImageView(frame: .zero)
   
   private let genderLabel  = GFTitleLabel()
   private let statusLabel  = GFTitleLabel()
   private let speciesLabel = GFTitleLabel()
   private let typeLabel    = GFTitleLabel()
   private let originLabel  = GFTitleLabel()
   private let detailsStackView = UIStackView()
   
   var onUpdate: ((Character) -> Void)?
   private var character: Character
   
   init(character: Character, bookmarkManager: BookmarkManagable) {
      self.character = character
      self.bookmarkManager = bookmarkManager
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = UIColor(hexString: "#3A0564")
      
      configureScrollContainerView()
      configureToolbar()
      configureTitleLabel()
      configureImageView()
      configureStackView()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(true, animated: animated)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      navigationController?.setNavigationBarHidden(false, animated: animated)
   }
}

private extension CharacterDetailVC {
   
   func configureScrollContainerView() {
      view.addSubview(scrollView)
      scrollView.addSubview(contentView)
      
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      contentView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         scrollView.topAnchor.constraint(equalTo: view.topAnchor),
         scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
         contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
         contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
         contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
         contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
         contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
      ])
   }
   
   func configureToolbar() {
      contentView.addSubview(bookmarkButton)
      contentView.addSubview(backButton)
      
      let bookmarkIcon = UIImage(named: character.isBookmarked ? BookmarkImage.bookmarkFilled.rawValue : BookmarkImage.bookmark.rawValue)
      let backIcon = UIImage(named: "back-icon")
      
      bookmarkButton.setImage(bookmarkIcon, for: .normal)
      backButton.setImage(backIcon, for: .normal)
      
      bookmarkButton.tintColor = .white
      backButton.tintColor = .white
      
      bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
      backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
      
      bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
      backButton.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
         bookmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
         bookmarkButton.widthAnchor.constraint(equalToConstant: 32),
         bookmarkButton.heightAnchor.constraint(equalToConstant: 32),
         
         backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
         backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
         backButton.widthAnchor.constraint(equalToConstant: 40),
         backButton.heightAnchor.constraint(equalToConstant: 40)
      ])
   }
   
   func configureTitleLabel() {
      contentView.addSubview(titleLabel)
      
      titleLabel.text = character.name
      titleLabel.textAlignment = .center
      titleLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
      titleLabel.textColor = .white
      titleLabel.adjustsFontSizeToFitWidth = true
      titleLabel.minimumScaleFactor = 0.8
      titleLabel.numberOfLines = 0
      titleLabel.lineBreakMode = .byWordWrapping
      
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
         titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 14),
         titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
         titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
      ])
   }
   
   func configureImageView() {
      contentView.addSubview(imageView)
      
      if let imageUrlString = character.image?.absoluteString {
         imageView.downloadImage(fromURL: imageUrlString)
      }
      
      imageView.layer.cornerRadius = 16
      imageView.clipsToBounds = true
      
      imageView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
         imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
         imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
         imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.85)
      ])
   }
   
   func configureStackView() {
      contentView.addSubview(detailsStackView)
      
      detailsStackView.axis = .vertical
      detailsStackView.spacing = 10
      detailsStackView.distribution = .fillEqually
      
      [genderLabel, statusLabel, speciesLabel, typeLabel, originLabel].forEach {
         detailsStackView.addArrangedSubview($0)
      }
      
      detailsStackView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         detailsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 36),
         detailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
         detailsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
         detailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
      ])
      
      genderLabel.attributedText = NSMutableAttributedString()
         .bold("Gender")
         .normal(": \(character.gender)")
      
      statusLabel.attributedText = NSMutableAttributedString()
         .bold("Status")
         .normal(": \(character.status)")
      
      speciesLabel.attributedText = NSMutableAttributedString()
         .bold("Species")
         .normal(": \(character.species)")
      
      typeLabel.attributedText = NSMutableAttributedString()
         .bold("Type")
         .normal(": \(character.type.isEmpty ? "N/A" : character.type)")
      
      originLabel.attributedText = NSMutableAttributedString()
         .bold("Origin")
         .normal(": \(character.origin.name)")
   }
}

// MARK: - Actions
private extension CharacterDetailVC {
   @objc func bookmarkButtonTapped() {
      Task {
         character.isBookmarked.toggle()
         await bookmarkManager.toggle(character)
         
         bookmarkButton.setImage(
            UIImage(named: character.isBookmarked ? BookmarkImage.bookmarkFilled.rawValue : BookmarkImage.bookmark.rawValue),
            for: .normal
         )
         
         onUpdate?(character)
      }
   }
   
   @objc func backButtonTapped() {
      navigationController?.popViewController(animated: true)
   }
}
