//
//  TodayViewController.swift
//  WorldTimeTodayWidget
//
//  Created by Max von Webel on 21/09/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

import UIKit
import NotificationCenter

struct Location {
    let name: String
    let timeZone: NSTimeZone
    
    init(name: String, timeZone: NSTimeZone) {
        self.name = name
        self.timeZone = timeZone;
    }
    
    init(name: String, timeZoneAbbrevation: String) {
        self.name = name
        self.timeZone = NSTimeZone(abbreviation: timeZoneAbbrevation)!
    }
}

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate {
    enum CellIdentifier : String {
        case TimeZone = "TimeZone"
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    var locations: [Location]!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clearColor()
        
        self.preferredContentSize = CGSize(width: 0, height: 50)
        
        locations = [
            Location(name: "San Francisco", timeZoneAbbrevation: "PST"),
            Location(name: "Berlin", timeZoneAbbrevation: "CET")
        ]
        
        collectionView.registerNib(UINib(nibName: "TimeZoneCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: CellIdentifier.TimeZone.rawValue)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clearColor()

        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.timeHidden = false
        print("viewWillAppear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.timeHidden = true
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    override func viewDidLayoutSubviews() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: self.collectionView.bounds.width / 2.0, height: self.preferredContentSize.height)
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var marginInsets = defaultMarginInsets
        marginInsets.bottom = 20.0
        return marginInsets
    }

    var timeHidden: Bool = false {
        didSet(oldTimeHidden) {
            self.collectionView.reloadData()
        }
    }
}

extension TodayViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.TimeZone.rawValue,
            forIndexPath: indexPath) as? TimeZoneCollectionViewCell else
        {
            assert(false)
            return UICollectionViewCell()
        }

        cell.location = locations[indexPath.row]
        cell.timeHidden = timeHidden
        
        return cell
    }
}
