//
//  UIHelper.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 20.10.25.
//

import UIKit

enum UIHelper {
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minItemSpacing: CGFloat = 10
        let availableScreenWidth = width - (padding * 2) - (minItemSpacing * 2)
        
        let availableItemWidth = availableScreenWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: availableItemWidth, height: availableItemWidth + 60)
        
        return flowLayout
    }
    
}
