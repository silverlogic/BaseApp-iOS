//
//  BaseCollectionViewHorizontalFlowLayout.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A base class for having subclasses of `UICollectionViewFlowLayout`. It also defines and sets default
/// attributes for an instance. This provides horizontal flow layout for `UICollectionView`.
class BaseCollectionViewHorizontalFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Instance Attributes
    var numberOfItemsPerColumn: Int = 2 {
        didSet {
            invalidateLayout()
        }
    }
    
    
    // MARK: - Lifecycle
    override func prepare() {
        super.prepare()
        guard let currentCollectionView = collectionView else { return }
        scrollDirection = .horizontal
        var newItemSize = itemSize
        let itemsPerColumn = CGFloat(max(numberOfItemsPerColumn, 1))
        let totalSpacingBetweenCells = minimumLineSpacing * (itemsPerColumn - 1.0)
        let height = (currentCollectionView.bounds.size.height - totalSpacingBetweenCells) / itemsPerColumn
        newItemSize.height = height
        if itemSize.width > 0 {
            let itemAspectRatio = itemSize.width / itemSize.height
            newItemSize.width = newItemSize.height / itemAspectRatio
        }
        itemSize = newItemSize
    }
}
