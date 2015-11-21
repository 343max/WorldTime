//
//  LocationsTableViewDataSource.swift
//  WorldTime
//
//  Created by Max von Webel on 20.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

class LocationsTableViewDataSource: LocationsDataSource, UITableViewDataSource, UITableViewDelegate {
    static let timeFormatter = NSDateFormatter.shortTime()

    let reuseIdentifier = "LocationSetupCell"

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: reuseIdentifier)
        }

        let location = locations[indexPath.row]
        cell.textLabel?.text = location.name
        cell.detailTextLabel?.text = location.stringFromDate(NSDate(), formatter: LocationsTableViewDataSource.timeFormatter)

        return cell
    }
}
