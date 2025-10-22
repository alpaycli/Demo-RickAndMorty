//
//  ListViewController.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 20.10.25.
//

import UIKit

class CharactersVC: UIViewController {
   
   private enum GenderFilterOption: String {
      case male = "Male"
      case female = "Female"
      case genderless = "Genderless"
      case unknown = "unknown"
   }
   
   private enum ClassificationFilterOption: String {
      case none = "none"
   }
   
   private enum StatusFilterOption: String {
      case dead = "Dead"
      case alive = "Alive"
      case unknown = "unknown"
   }
   
   private enum Section: Hashable {
      case main
   }
   
   private var dataSource: UICollectionViewDiffableDataSource<Section, Character>?
   private var collectionView: UICollectionView!
   
   private lazy var genderView = FilterButtonView(title: "Gender Type", menu: makeGenderTypeMenu())
   private lazy var classificationView = FilterButtonView(title: "Classifications", menu: makeClassificationTypeMenu())
   private lazy var statusView = FilterButtonView(title: "Status", menu: makeStatusTypeMenu())

   
   private var selectedGenderFilter: GenderFilterOption? {
      didSet {
         genderView.updateFilter(title: selectedGenderFilter?.rawValue,
                                 defaultTitle: "Gender Type")
         resetListWithExistingFilters()
      }
   }
   private var selectedClassificationFilter: ClassificationFilterOption?
   private var selectedStatusFilter: StatusFilterOption? {
      didSet {
         statusView.updateFilter(title: selectedStatusFilter?.rawValue,
                                 defaultTitle: "Status Type")
         resetListWithExistingFilters()

      }
   }
   private var filtersStackView = UIStackView()
   
   private let bookmarkManager: BookmarkManagable
   private let networkManager = NetworkManager.shared
   private var characters: [Character] = []
   private var filteredCharacters: [Character] = []
   
   init(bookmarkManager: BookmarkManagable) {
      self.bookmarkManager = bookmarkManager
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupNavigationBar()
      configureFiltersStackView()
      configureCollectionView()
      configureDataSource()
      configureSearchBar()
      Task {
         await fetchCharacters()
      }
   }
   
   private func configureFiltersStackView() {
      filtersStackView.axis = .horizontal
      filtersStackView.spacing = 10
      view.addSubview(filtersStackView)
      
      filtersStackView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         filtersStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
         filtersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         filtersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         filtersStackView.heightAnchor.constraint(equalToConstant: 40),
      ])
            
      // Assign clear actions
      genderView.onClear = { [weak self] in
         self?.selectedGenderFilter = nil
         self?.genderView.updateFilter(title: nil, defaultTitle: "Gender Type")
         self?.resetListWithExistingFilters()
      }
      classificationView.onClear = {}
      statusView.onClear = { [weak self] in
         self?.selectedStatusFilter = nil
         self?.statusView.updateFilter(title: nil, defaultTitle: "Status Type")
         self?.resetListWithExistingFilters()
      }

      filtersStackView.addArrangedSubview(genderView)
      filtersStackView.addArrangedSubview(classificationView)
      filtersStackView.addArrangedSubview(statusView)
   }
   
   private func resetListWithExistingFilters() {
      if selectedGenderFilter == nil,
         selectedStatusFilter == nil,
         selectedClassificationFilter == nil
      {
         filteredCharacters = characters
         updateData(filteredCharacters)
         return
      }
      filteredCharacters = characters
      
      if let name = selectedGenderFilter?.rawValue {
         filteredCharacters = filteredCharacters.filter({ $0.gender == name })
      }
      if let _ = selectedClassificationFilter?.rawValue {
//         filteredCharacters = filteredCharacters.filter({ $0. })
      }
      if let name = selectedStatusFilter?.rawValue {
         filteredCharacters = filteredCharacters.filter({ $0.status == name })
      }
      updateData(filteredCharacters)
   }
   
   private func makeGenderTypeMenu() -> UIMenu {
      let female = UIAction(title: "Female", handler: { _ in self.selectedGenderFilter = .female })
      let male = UIAction(title: "Male", handler: { _ in self.selectedGenderFilter = .male })
      let genderless = UIAction(title: "Genderless", handler: { _ in self.selectedGenderFilter = .genderless })
      let unknown = UIAction(title: "unknown", handler: { _ in self.selectedGenderFilter = .unknown })
      
      return UIMenu(title: "", children: [female, male, genderless, unknown])
   }
   
   private func makeClassificationTypeMenu() -> UIMenu {
      return UIMenu(title: "", children: [])
   }
   
   private func makeStatusTypeMenu() -> UIMenu {
      let dead = UIAction(title: "Dead", handler: { _ in self.selectedStatusFilter = .dead })
      let alive = UIAction(title: "Alive", handler: { _ in self.selectedStatusFilter = .alive })
      let unknown = UIAction(title: "Unknown", handler: { _ in self.selectedStatusFilter = .unknown })
      return UIMenu(title: "", children: [dead, alive, unknown])
   }
   
   private func configureSearchBar() {
      let searchController = UISearchController(searchResultsController: nil)
      searchController.searchResultsUpdater = self
      navigationItem.searchController = searchController
   }
   
   private func fetchCharacters() async {
      let urlString = "https://rickandmortyapi.com/api/character"
      guard let url = URL(string: urlString) else { return }
      
      let urlRequest = URLRequest(url: url)

      do {
         let response = try await networkManager.fetch(CharacterResponse.self, url: urlRequest)
         let characters = response.results
         self.characters = characters
         updateData(characters)
      } catch {
         print("Error", error.localizedDescription)
      }
      
   }
   
   private func setupNavigationBar() {
      navigationItem.title = "Rick and Morty"
      navigationController?.navigationBar.prefersLargeTitles = true
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
         collectionView.topAnchor.constraint(equalTo: filtersStackView.bottomAnchor, constant: 15),
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
      let character = characters[indexPath.row]
      let destinationVC = CharacterDetailVC(character: character, bookmarkManager: bookmarkManager)
      
      destinationVC.onUpdate = { [weak self] updatedCharacter in
         guard let self else { return }
         if let index = characters.firstIndex(where: { $0.id == updatedCharacter.id }) {
            characters[index] = updatedCharacter
            updateData(self.characters)
         }
      }
      
      navigationController?.pushViewController(destinationVC, animated: true)
   }
}

// MARK: - UISearchResultsUpdating

extension CharactersVC: UISearchResultsUpdating {
   func updateSearchResults(for searchController: UISearchController) {
      guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
          // If search text is empty, display all items
         updateData(characters)
          return
      }

      let filteredItems = characters.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
      updateData(filteredItems)
   }
}
