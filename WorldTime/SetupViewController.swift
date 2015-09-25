//
//  ViewController.swift
//  WorldTime
//
//  Created by Max von Webel on 21/09/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let collectionViewSource = LocationsCollectionViewDataSource()

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.removeFromSuperview()

        collectionViewSource.collectionView = collectionView
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        collectionViewSource.locations = Location.fromDefaults()
        collectionViewSource.updateItemSize()

        collectionView.backgroundColor = UIColor.orangeColor()

        collectionView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
    }
}

