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
    enum Cell : String {
        case TimeZone = "TimeZoneCollectionViewCell"

        var identifier: String {
            return self.rawValue
        }

        var nibName: String {
            return self.rawValue
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!

    var collectionViewSource = LocationsCollectionViewDataSource()

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clearColor()
        
        self.preferredContentSize = CGSize(width: 0, height: 50)

        collectionViewSource.prepare(collectionView: collectionView)

        collectionView.backgroundColor = UIColor.clearColor()

        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionViewSource.locations = Location.fromDefaults()

        super.viewWillAppear(animated)

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

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: self.collectionView.bounds.width / CGFloat(collectionViewSource.locations.count),
                                    height: self.preferredContentSize.height)
        }
    }

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var marginInsets = defaultMarginInsets
        marginInsets.bottom = 10.0
        return marginInsets
    }

    var timeHidden: Bool = false {
        didSet(oldTimeHidden) {
            for cell in self.collectionView.visibleCells() {
                if let cell = cell as? TimeZoneCollectionViewCell {
                    cell.timeHidden = timeHidden
                }
            }
        }
    }
}
