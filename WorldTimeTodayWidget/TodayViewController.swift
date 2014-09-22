//
//  TodayViewController.swift
//  WorldTimeTodayWidget
//
//  Created by Max von Webel on 21/09/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

import UIKit
import NotificationCenter

struct TimeZone {
    let locationName: String
    let timeZone: NSTimeZone
    
    init(locationName: String, timeZone: NSTimeZone) {
        self.locationName = locationName
        self.timeZone = timeZone;
    }
    
    init(locationName: String, timeZoneAbbrevation: String) {
        self.locationName = locationName
        self.timeZone = NSTimeZone(abbreviation: timeZoneAbbrevation)
    }
}

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var timeZones: [TimeZone]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: 0, height: 100)
        
        timeZones = [
            TimeZone(locationName: "San Francisco", timeZoneAbbrevation: "PST"),
            TimeZone(locationName: "Berlin", timeZoneAbbrevation: "CET")
        ]
        
        collectionView.registerNib(UINib(nibName: "TimeZoneCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeZone")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
}

extension TodayViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.timeZones.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimeZone", forIndexPath: indexPath) as TimeZoneCollectionViewCell
        
        cell.timeZone = timeZones[indexPath.row]
        
        return cell
    }
}

extension TodayViewController: UICollectionViewDelegate {
    
}