// Copyright 2014-present Max von Webel. All Rights Reserved.

import UIKit

class WorldTimeLayout: UICollectionViewLayout {
    var columns = 2
    var rows = 0
    var count: Int = 0 {
        didSet {
            columns = min(count, 3)
            rows = Int(ceil(Float(count) / Float(columns)))
        }
    }

    func prepareLayout(itemCount: Int) {
        self.count = itemCount
    }

    override func prepare() {
        super.prepare()

        guard let dataSource = self.collectionView?.dataSource, let collectionView = self.collectionView else {
            count = 0
            return
        }

        self.prepareLayout(itemCount: dataSource.collectionView(collectionView, numberOfItemsInSection: 0))
    }

    override var collectionViewContentSize: CGSize {
        get {
            guard let collectionView = self.collectionView else {
                return CGSize.zero
            }
            
            return CGSize(width: collectionView.bounds.width, height: CGFloat(rows) * TimeZoneCollectionViewCell.preferedHeight)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else {
            return []
        }

        let itemSize = CGSize(width: collectionView.bounds.width / CGFloat(columns), height: TimeZoneCollectionViewCell.preferedHeight)
        let range = 0..<count
        return range.map({ (i) -> UICollectionViewLayoutAttributes in
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0) as IndexPath)
            let column = i % columns
            let row = (i - column) / columns
            let origin = CGPoint(x: itemSize.width * CGFloat(column), y: itemSize.height * CGFloat(row))
            attributes.frame = CGRect(origin: origin, size: itemSize)
            return attributes
        })
    }
}
