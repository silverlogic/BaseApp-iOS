//
//  BaseCollectionViewVerticalFlowLayout.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A base class for having subclasses of `UICollectionViewFlowLayout`. It also defines and sets default
/// attributes for an instance. This provides vertical flow layout for `UICollectionView`.
class BaseCollectionViewVerticalFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Instance Attributes
    var numberOfItemsPerRow: Int = 2 {
        didSet {
            invalidateLayout()
        }
    }
    
    
    // MARK: - Lifecycle
    override func prepare() {
        super.prepare()
        guard let currentCollectionView = collectionView else { return }
        scrollDirection = .vertical
        var newItemSize = itemSize
        let itemsPerRow = CGFloat(max(numberOfItemsPerRow, 1))
        let totalSpacingBetweenCells = minimumInteritemSpacing * (itemsPerRow - 1.0)
        newItemSize.width = (currentCollectionView.bounds.size.width - totalSpacingBetweenCells) / itemsPerRow
        if itemSize.height > 0 {
            let itemAspectRatio = itemSize.width / itemSize.height
            newItemSize.height = newItemSize.width / itemAspectRatio
        }
        itemSize = newItemSize
    }
}
