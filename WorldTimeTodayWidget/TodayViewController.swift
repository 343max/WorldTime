//
//  TodayViewController.swift
//  WorldTimeTodayWidget
//
//  Created by Max von Webel on 21/09/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var collectionView: UICollectionView!

    var collectionViewSource = LocationsCollectionViewDataSource()

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clearColor()
        
        self.preferredContentSize = CGSize(width: 0, height: TimeZoneCollectionViewCell.preferedHeight)

        collectionView.backgroundColor = UIColor.clearColor()
        collectionViewSource.prepare(collectionView: collectionView)

        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        collectionViewSource.locations = Location.fromDefaults()
        self.timeHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        self.timeHidden = true
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.collectionView.frame = self.view.bounds
        collectionViewSource.updateItemSize(collectionView: self.collectionView)
    }

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var marginInsets = defaultMarginInsets
        marginInsets.bottom = 10.0
        return marginInsets
    }

    var timeHidden: Bool = false {
        didSet(oldTimeHidden) {
            collectionViewSource.timeHidden = timeHidden
            collectionView.reloadData()
        }
    }
}
