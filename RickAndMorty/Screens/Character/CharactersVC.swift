//
//  ListViewController.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 20.10.25.
//

import UIKit

class CharactersVC: UIViewController {
   
   private enum Section: Hashable {
      case main
   }
   
   private var navTitleLabel = UILabel()
   private var navSubtitleLabel = UILabel()
   private let searchField = SearchTextField()
   private var dataSource: UICollectionViewDiffableDataSource<Section, Character>?
   private var collectionView: UICollectionView!
   
   private lazy var genderView = FilterButtonView(title: "Gender Type", menu: viewModel.makeGenderTypeMenu())
   private lazy var classificationView = FilterButtonView(title: "Classifications", menu: viewModel.makeClassificationTypeMenu())
   private lazy var statusView = FilterButtonView(title: "Status", menu: viewModel.makeStatusTypeMenu())

   
   private var filtersStackView = UIStackView()
   
   private let viewModel: CharactersViewModel
   
   init(bookmarkManager: BookmarkManagable) {
      self.viewModel = .init(bookmarkManager: bookmarkManager)
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      viewModel.output = self
      setupNavigationBar()
      configureSearchBar()
      configureFiltersStackView()
      configureCollectionView()
      configureDataSource()
      Task {
         await viewModel.fetchCharacters()
      }
   }
   
   override func viewWillAppear(_ animated: Bool) {
      self.navigationController?.setNavigationBarHidden(true, animated: animated)
   }
   
   private func configureFiltersStackView() {
      filtersStackView.axis = .horizontal
      filtersStackView.spacing = 10
      view.addSubview(filtersStackView)
      
      filtersStackView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         filtersStackView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
         filtersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         filtersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
         filtersStackView.heightAnchor.constraint(equalToConstant: 40),
      ])
            
      genderView.onClear = { [weak self] in
         self?.viewModel.selectedGenderFilter = nil
         self?.genderView.updateFilter(title: nil, defaultTitle: "Gender Type")
         self?.viewModel.resetListWithExistingFilters()
      }
      classificationView.onClear = {}
      statusView.onClear = { [weak self] in
         self?.viewModel.selectedStatusFilter = nil
         self?.statusView.updateFilter(title: nil, defaultTitle: "Status Type")
         self?.viewModel.resetListWithExistingFilters()
      }

      filtersStackView.addArrangedSubview(genderView)
      filtersStackView.addArrangedSubview(classificationView)
      filtersStackView.addArrangedSubview(statusView)
   }
   
   private func configureSearchBar() {
      searchField.delegate = self
      searchField.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(searchField)

      NSLayoutConstraint.activate([
         searchField.topAnchor.constraint(equalTo: navSubtitleLabel.bottomAnchor, constant: 20),
          searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
          searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
          searchField.heightAnchor.constraint(equalToConstant: 44)
      ])
   }
   
   private func setupNavigationBar() {
      navTitleLabel.numberOfLines = 2
      navTitleLabel.font = UIFont(name: "IrishGrover-Regular", size: 44)
      navTitleLabel.textColor = .white
      navTitleLabel.text = "Rick and Morty"
      
      navSubtitleLabel.numberOfLines = 2
      navSubtitleLabel.font = UIFont(name: "IrishGrover-Regular", size: 24)
      navSubtitleLabel.textColor = .white
      navSubtitleLabel.text = "fandom"
      
      view.addSubview(navTitleLabel)
      view.addSubview(navSubtitleLabel)
      
      navTitleLabel.translatesAutoresizingMaskIntoConstraints = false
      navSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         navTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
         navTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         navTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
         navTitleLabel.heightAnchor.constraint(equalToConstant: 44),
         
         
         navSubtitleLabel.topAnchor.constraint(equalTo: navTitleLabel.bottomAnchor, constant: 0),
         navSubtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         navSubtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
         navSubtitleLabel.heightAnchor.constraint(equalToConstant: 24),
      ])
   }

}

// MARK: - CollectionView and (Compositionl) Layout

extension CharactersVC {
   private func configureCollectionView() {
      collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
      view.addSubview(collectionView)
      
      collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseId)
      collectionView.delegate = self
      
      view.backgroundColor = .init(hexString: "#3A0564")
      collectionView.backgroundColor = .init(hexString: "#3A0564")
      
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         collectionView.topAnchor.constraint(equalTo: filtersStackView.bottomAnchor, constant: 25),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      ])
   }
   
   private func configureDataSource() {
       dataSource = UICollectionViewDiffableDataSource<Section, Character>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, character) -> UICollectionViewCell? in
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseId, for: indexPath) as! CharacterCell
           cell.set(character: character)
           return cell
       })
   }
   
   private func updateData(_ data: [Character]) {
       var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
       snapshot.appendSections([.main])
       snapshot.appendItems(data)
       
       guard let dataSource else { return }
       DispatchQueue.main.async {
           dataSource.apply(snapshot, animatingDifferences: true)
       }
   }

   
   private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
      
      return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection? in
         switch section {
            case 0: return self.createFirstSection()
            default: return self.createFirstSection()
         }
      }
   }
   
   private func createFirstSection() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
      
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 60, trailing: 5)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.50), heightDimension: .fractionalHeight(0.55))
      
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 2)
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .paging
      
      return section
   }
}

// MARK: - UICollectionViewDelegate

extension CharactersVC: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      viewModel.didSelectItem(at: indexPath, navController: navigationController)
   }
}

// MARK: - Search Field delegate

extension CharactersVC: UITextFieldDelegate {
   func textFieldDidChangeSelection(_ textField: UITextField) {
      guard let searchText = textField.text else { return }
      viewModel.updateSearchResults(searchText: searchText)
   }
}

// MARK: - ViewModel communication

extension CharactersVC: CharacterViewModelOutput {
   func genderFilterUpdated(_ genderFilterOption: GenderFilterOption?) {
      genderView.updateFilter(title: genderFilterOption?.rawValue,
                              defaultTitle: "Gender Type")
   }
   
   func classificationFilterUpdated(_ classificationFilterOption: ClassificationFilterOption?) {
      classificationView.updateFilter(title: classificationFilterOption?.rawValue,
                              defaultTitle: "Classification")
   }
   
   func statusFilterUpdated(_ statusFilterOption: StatusFilterOption?) {
      statusView.updateFilter(title: statusFilterOption?.rawValue,
                              defaultTitle: "Status")
   }
   
    func updateView(with characters: [Character]) {
        updateData(characters)
    }
}
