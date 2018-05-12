// Copyright 2014-present Max von Webel. All Rights Reserved.

import UIKit

class LocationsCollectionViewDataSource: LocationsDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    let reuseIdentifier = "TimeZoneCollectionViewCell"
    var timeHidden = false

    func prepare(collectionView: UICollectionView) {
        let nib = UINib(nibName: self.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath)
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
