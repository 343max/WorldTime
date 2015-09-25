//
//  LocationsCollectionViewDataSource.swift
//  WorldTime
//
//  Created by Max von Webel on 24.09.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

class LocationsCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    static let reuseIdentifier = "TimeZoneCollectionViewCell"

    var locations: [Location] = []
    var timeHidden = false

    func prepare(collectionView collectionView: UICollectionView) {
        let nib = UINib(nibName: LocationsCollectionViewDataSource.reuseIdentifier, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: LocationsCollectionViewDataSource.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func updateItemSize(collectionView collectionView: UICollectionView) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = TimeZoneCollectionViewCell.preferredItemSize(collectionViewWidth: collectionView.bounds.width, itemCount: locations.count)
        } else {
            assert(false, "this needs to be an collectionViewFlowLayout")
        }
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LocationsCollectionViewDataSource.reuseIdentifier,
            forIndexPath: indexPath)
            as? TimeZoneCollectionViewCell else
        {
            assert(false)
            return UICollectionViewCell()
        }

        cell.location = locations[indexPath.row]
        cell.timeHidden = timeHidden

        return cell
    }

}
