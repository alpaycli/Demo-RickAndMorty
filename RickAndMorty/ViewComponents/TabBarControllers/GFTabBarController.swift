//
//  GFTabBarController.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 20.10.25.
//


import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createCharactersVCNC(), createFavoritesNC()]
    }
    

    func createCharactersVCNC() -> UINavigationController {
        let searchVC = CharactersVC()
        searchVC.title = "CharactersVC"
       searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC = FavoritesVC()
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesVC)
    }

}
