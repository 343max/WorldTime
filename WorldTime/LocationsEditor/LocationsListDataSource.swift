//
//  LocationsTableViewDataSource.swift
//  WorldTime
//
//  Created by Max von Webel on 20.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

protocol LocationsListDataSourceDelegate: class {

    func didChangeLocations(locations: [Location])
    func didSelectLocation(location: Location)

}

class LocationsListDataSource: LocationsDataSource, UITableViewDataSource, UITableViewDelegate {
    static let timeFormatter = NSDateFormatter.shortTime()

    let reuseIdentifier = "LocationSetupCell"

    weak var delegate: LocationsListDataSourceDelegate?

    func updateTimeInCell(cell: UITableViewCell, location: Location) {
        cell.detailTextLabel?.text = location.stringFromDate(NSDate(), formatter: LocationsListDataSource.timeFormatter)
    }

    func addLocation(location: Location, tableView: UITableView) {
        let indexPath = NSIndexPath(forRow: locations.count, inSection: 0)
        locations.append(location)
        tableView.insertRowsAtIndexPaths([ indexPath ], withRowAnimation: .Automatic)
        self.delegate?.didChangeLocations(locations)
    }

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
        cell.accessoryType = .DisclosureIndicator
        self.updateTimeInCell(cell, location: location)

        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            locations.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([ indexPath ], withRowAnimation: .Automatic)
        case .Insert, .None:
            fatalError("not implemented")
        }
        self.delegate?.didChangeLocations(locations)
    }

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let location = locations[sourceIndexPath.row]
        locations.removeAtIndex(sourceIndexPath.row)
        locations.insert(location, atIndex: destinationIndexPath.row)
        self.delegate?.didChangeLocations(locations)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.didSelectLocation(locations[indexPath.row])
    }
}
