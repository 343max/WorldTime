//
//  LocationsDataSource+CollectionView.swift
//  WorldTime
//
//  Created by Max von Webel on 20.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

class LocationsCollectionViewDataSource: LocationsDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    let reuseIdentifier = "TimeZoneCollectionViewCell"
    var timeHidden = false

    func prepare(collectionView collectionView: UICollectionView) {
        let nib = UINib(nibName: self.reuseIdentifier, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath)
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