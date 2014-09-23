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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clearColor()
        
        self.preferredContentSize = CGSize(width: 0, height: 50)
        
        timeZones = [
            TimeZone(locationName: "San Francisco", timeZoneAbbrevation: "PST"),
            TimeZone(locationName: "Berlin", timeZoneAbbrevation: "CET")
        ]
        
        collectionView.registerNib(UINib(nibName: "TimeZoneCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeZone")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clearColor()

        super.viewDidLoad()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    override func viewDidLayoutSubviews() {
        with(collectionView.collectionViewLayout as UICollectionViewFlowLayout) { layout in
            layout.itemSize = CGSize(width: self.collectionView.bounds.width / 2.0, height: self.preferredContentSize.height)
        }
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