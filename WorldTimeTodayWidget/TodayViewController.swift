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
    var minuteChangeNotifier: MinuteChangeNotifier?

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear

        collectionView.backgroundColor = UIColor.clear
        collectionViewSource.prepare(collectionView: collectionView)

        setup()

        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setup()

        self.minuteChangeNotifier = MinuteChangeNotifier(delegate: self)
        self.timeHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.timeHidden = true
        self.minuteChangeNotifier = nil
    }

    func setup() {
        collectionViewSource.locations = Location.fromDefaults()
        collectionView.reloadData()

        guard let layout = collectionView.collectionViewLayout as? WorldTimeLayout else {
            fatalError("not a WorldTimeLayout")
        }

        layout.prepareLayout(itemCount: collectionViewSource.locations.count)
        self.preferredContentSize = layout.collectionViewContentSize
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.collectionView.frame = self.view.bounds
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

extension TodayViewController: MinuteChangeNotifierDelegate {
    func minuteDidChange(notifier: MinuteChangeNotifier) {
        for cell in collectionView.visibleCells {
            if let cell = cell as? TimeZoneCollectionViewCell {
                cell.updateTime()
            }
        }
    }
}
