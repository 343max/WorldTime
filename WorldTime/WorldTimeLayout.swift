//
//  WorldTimeLayout.swift
//  WorldTime
//
//  Created by Max von Webel on 20.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

class WorldTimeLayout: UICollectionViewLayout {
    let cellHeight: CGFloat = 50.0
    let columns = 2

    var itemCount = 0
    var rows = 0

    func prepareLayout(itemCount: Int) {
        self.itemCount = itemCount
        rows = Int(ceil(Float(itemCount) / Float(columns)))
    }

    override func prepareLayout() {
        super.prepareLayout()

        guard let dataSource = self.collectionView?.dataSource, let collectionView = self.collectionView else {
            rows = 0
            itemCount = 0
            return
        }

        assert(dataSource.numberOfSectionsInCollectionView?(collectionView) == 1)
        self.prepareLayout(dataSource.collectionView(collectionView, numberOfItemsInSection: 0))
    }

    override func collectionViewContentSize() -> CGSize {
        guard let collectionView = self.collectionView else {
            return CGSize.zero
        }

        return CGSize(width: collectionView.bounds.width, height: CGFloat(rows) * cellHeight)
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else {
            return []
        }

        let itemSize = CGSize(width: collectionView.bounds.width / CGFloat(columns), height: cellHeight)
        let range = 0..<itemCount
        return range.map({ (i) -> UICollectionViewLayoutAttributes in
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: i, inSection: 0))
            let column = i % columns
            let row = (i - column) / columns
            let origin = CGPoint(x: itemSize.width * CGFloat(column), y: itemSize.height * CGFloat(row))
            attributes.frame = CGRect(origin: origin, size: itemSize)
            return attributes
        })
    }
}
