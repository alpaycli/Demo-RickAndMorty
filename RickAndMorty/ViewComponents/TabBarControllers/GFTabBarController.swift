//
//  GFTabBarController.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 20.10.25.
//


import UIKit

class GFTabBarController: UITabBarController {
   
   private let bookmarkManager: BookmarkManagable = BookmarkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
       overrideUserInterfaceStyle = .dark
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createCharactersVCNC(), createFavoritesNC()]
       checkFonts()
    }
    

    func createCharactersVCNC() -> UINavigationController {
        let searchVC = CharactersVC(bookmarkManager: bookmarkManager)
        searchVC.title = "CharactersVC"
       searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC = FavoritesVC(bookmarkManager: bookmarkManager)
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesVC)
    }

   private func checkFonts() {
      for family in UIFont.familyNames.sorted() {
          let names = UIFont.fontNames(forFamilyName: family)
          print("Family: \(family) Font names: \(names)")
      }
   }
}
