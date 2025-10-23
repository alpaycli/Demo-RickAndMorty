//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 22.10.25.
//

import UIKit
import Foundation

protocol CharacterViewModelOutput: AnyObject {
   func updateView(with characters: [Character])
   
   // These are for updating filter UIViews
   func genderFilterUpdated(_ genderFilterOption: GenderFilterOption?)
   func classificationFilterUpdated(_ classificationFilterOption: ClassificationFilterOption?)
   func statusFilterUpdated(_ statusFilterOption: StatusFilterOption?)
}

class CharactersViewModel {
   let bookmarkManager: BookmarkManagable
   let networkManager = NetworkManager.shared
   var characters: [Character] = []
   var filteredCharacters: [Character] = []
   
   private var page = 1
   private var hasMoreCharacters: Bool = true
   private var isLoadingCharacters = false
   
   weak var output: CharacterViewModelOutput?
   
   var selectedGenderFilter: GenderFilterOption? {
      didSet {
         output?.genderFilterUpdated(selectedGenderFilter)
         resetListWithExistingFilters()
      }
   }
   var selectedClassificationFilter: ClassificationFilterOption?
   var selectedStatusFilter: StatusFilterOption? {
      didSet {
         output?.statusFilterUpdated(selectedStatusFilter)
         resetListWithExistingFilters()
      }
   }
   
   init(bookmarkManager: BookmarkManagable) {
      self.bookmarkManager = bookmarkManager
   }
   
   func handleScrollViewForPagination(_ scrollView: UIScrollView) {
       let scrollY = scrollView.contentOffset.y
       let contentHeight = scrollView.contentSize.height
       let screenHeight = scrollView.frame.size.height
       
       if scrollY > contentHeight - screenHeight {
           guard hasMoreCharacters, !isLoadingCharacters else { return }
           page += 1
           Task {
              await fetchCharacters()
           }
       }
   }
   
   func didSelectItem(at indexPath: IndexPath, navController: UINavigationController?) {
      let character = characters[indexPath.row]
      let destinationVC = CharacterDetailVC(character: character, bookmarkManager: bookmarkManager)
      
      destinationVC.onUpdate = { [weak self] updatedCharacter in
         guard let self else { return }
         if let index = characters.firstIndex(where: { $0.id == updatedCharacter.id }) {
            characters[index] = updatedCharacter
            output?.updateView(with: characters)
         }
      }
      
      navController?.pushViewController(destinationVC, animated: true)
   }
   
   func updateSearchResults(for searchController: UISearchController) {
      guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
          // If search text is empty, display all items
         output?.updateView(with: characters)
          return
      }

      let filteredItems = characters.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
      output?.updateView(with: filteredItems)
   }
   
   func updateSearchResults(searchText: String) {
      guard !searchText.isEmpty else {
          // If search text is empty, display all items
         output?.updateView(with: characters)
          return
      }
      
      let filteredItems = characters.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
      output?.updateView(with: filteredItems)
   }
   
   func fetchCharacters() async {
      let urlString = "https://rickandmortyapi.com/api/character/?page=\(page)"
      guard let url = URL(string: urlString) else { return }
      
      let urlRequest = URLRequest(url: url)

      isLoadingCharacters = true
      do {
         let response = try await networkManager.fetch(CharacterResponse.self, url: urlRequest)
         let result = response.results
         characters.append(contentsOf: result)
         output?.updateView(with: characters)
         if response.results.count < 20 { self.hasMoreCharacters = false }
         isLoadingCharacters = false
      } catch {
         print("Error", error.localizedDescription)
         isLoadingCharacters = false
      }
      
   }
   
   func resetListWithExistingFilters() {
      if selectedGenderFilter == nil,
         selectedStatusFilter == nil,
         selectedClassificationFilter == nil
      {
         filteredCharacters = characters
         output?.updateView(with: filteredCharacters)
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
      output?.updateView(with: filteredCharacters)
   }
}

// MARK: - Menus

extension CharactersViewModel {
   func makeGenderTypeMenu() -> UIMenu {
      let female = UIAction(title: "Female", handler: { _ in self.selectedGenderFilter = .female })
      let male = UIAction(title: "Male", handler: { _ in self.selectedGenderFilter = .male })
      let genderless = UIAction(title: "Genderless", handler: { _ in self.selectedGenderFilter = .genderless })
      let unknown = UIAction(title: "unknown", handler: { _ in self.selectedGenderFilter = .unknown })
      
      return UIMenu(title: "", children: [female, male, genderless, unknown])
   }
   
   func makeClassificationTypeMenu() -> UIMenu {
      return UIMenu(title: "", children: [])
   }
   
   func makeStatusTypeMenu() -> UIMenu {
      let dead = UIAction(title: "Dead", handler: { _ in self.selectedStatusFilter = .dead })
      let alive = UIAction(title: "Alive", handler: { _ in self.selectedStatusFilter = .alive })
      let unknown = UIAction(title: "Unknown", handler: { _ in self.selectedStatusFilter = .unknown })
      return UIMenu(title: "", children: [dead, alive, unknown])
   }
}

enum GenderFilterOption: String {
   case male = "Male"
   case female = "Female"
   case genderless = "Genderless"
   case unknown = "unknown"
}

enum ClassificationFilterOption: String {
   case none = "none"
}

enum StatusFilterOption: String {
   case dead = "Dead"
   case alive = "Alive"
   case unknown = "unknown"
}
