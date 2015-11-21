//
//  ViewController.swift
//  WorldTime
//
//  Created by Max von Webel on 21/09/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    let collectionViewSource = LocationsCollectionViewDataSource()

    weak var collectionView: UICollectionView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "World Time"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        self.collectionView = collectionView
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(collectionView)

        collectionViewSource.prepare(collectionView: collectionView)
        collectionViewSource.textColor = UIColor.blackColor()

        collectionView.frame = self.view.bounds
        collectionView.backgroundColor = UIColor.clearColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        collectionViewSource.locations = Location.fromDefaults()
        collectionViewSource.updateItemSize(collectionView: collectionView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionViewSource.updateItemSize(collectionView: collectionView)
    }
}

