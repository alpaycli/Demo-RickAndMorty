//
//  CharacterDetailVC.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 21.10.25.
//

import UIKit

class CharacterDetailVC: UIViewController {
   
   private let bookmarkManager: BookmarkManagable
   
   private let bookmarkButton = UIButton()
   private let backButton = UIButton()
   
   private let titleLabel = UILabel()
   private let imageView = GFAvatarImageView(frame: .zero)
   
   private let genderLabel      = GFTitleLabel()
   private let statusLabel      = GFTitleLabel()
   private let speciesLabel     = GFTitleLabel()
   private let typeLabel        = GFTitleLabel()
   private let originLabel      = GFTitleLabel()
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
      configureToolbar()
      configureTitleLabel()
      configureImageView()
      configureStackView()
      view.backgroundColor = .init(hexString: "#3A0564")
   }
   
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.navigationController?.setNavigationBarHidden(true, animated: animated)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
      bookmarkButton.setImage(.init(named: character.isBookmarked ? BookmarkImage.bookmarkFilled.rawValue : BookmarkImage.bookmark.rawValue), for: .normal)
   }
   
   private func configureTitleLabel() {
      view.addSubview(titleLabel)
      
      titleLabel.text = character.name
      titleLabel.textAlignment = .center
      titleLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
      titleLabel.adjustsFontSizeToFitWidth = true
      titleLabel.minimumScaleFactor = 0.9
      titleLabel.numberOfLines = 0
      titleLabel.lineBreakMode = .byWordWrapping
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         titleLabel.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor, constant: 14),
         titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
         titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
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
   
   private func configureToolbar() {
      view.addSubview(bookmarkButton)
      view.addSubview(backButton)
      
      let bookmarkIcon = UIImage(named: BookmarkImage.bookmark.rawValue)
      let backIcon = UIImage(named: "back-icon")
      bookmarkButton.setImage(bookmarkIcon, for: .normal)
      backButton.setImage(backIcon, for: .normal)
      
      bookmarkButton.addTarget(nil, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
      backButton.addTarget(nil, action: #selector(backButtonTapped), for: .touchUpInside)
      
      bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
      backButton.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         bookmarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         bookmarkButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         bookmarkButton.widthAnchor.constraint(equalToConstant: 32),
         bookmarkButton.heightAnchor.constraint(equalToConstant: 32),
         
         backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         backButton.widthAnchor.constraint(equalToConstant: 40),
         backButton.heightAnchor.constraint(equalToConstant: 40)
      ])
   }
   
   @objc func bookmarkButtonTapped() {
      Task {
         await bookmarkManager.toggle(character)
         character.isBookmarked.toggle()
         
         bookmarkButton.setImage(.init(named: character.isBookmarked ? BookmarkImage.bookmarkFilled.rawValue : BookmarkImage.bookmark.rawValue), for: .normal)
         onUpdate?(character)
      }
   }
   
   @objc func backButtonTapped() {
      self.navigationController?.popViewController(animated: true)
   }
}
