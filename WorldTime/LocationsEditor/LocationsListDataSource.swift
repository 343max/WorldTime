//
//  LocationsTableViewDataSource.swift
//  WorldTime
//
//  Created by Max von Webel on 20.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

protocol LocationsListDataSourceDelegate: class {

    func didChange(locations: [Location])
    func didSelect(location: Location, index: Int)

}

class LocationsListDataSource: LocationsDataSource, UITableViewDataSource, UITableViewDelegate {
    static let timeFormatter = DateFormatter.shortTime()

    let reuseIdentifier = "LocationSetupCell"

    weak var delegate: LocationsListDataSourceDelegate?

    func updateTimeInCell(cell: UITableViewCell, location: Location) {
        cell.detailTextLabel?.text = location.stringFromDate(date: NSDate(), formatter: LocationsListDataSource.timeFormatter)
    }

    func add(location: Location, tableView: UITableView) {
        let indexPath = NSIndexPath(row: locations.count, section: 0)
        locations.append(location)
        tableView.insertRows(at: [ indexPath as IndexPath ], with: .automatic)
        self.delegate?.didChange(locations: locations)
    }

    func update(location: Location, index: Int, tableView: UITableView) {
        let indexPath = NSIndexPath(row: index, section: 0)
        locations[index] = location
        tableView.reloadRows(at: [ indexPath as IndexPath ], with: .automatic)
        self.delegate?.didChange(locations: locations)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
        }

        let location = locations[indexPath.row]
        cell.textLabel?.text = location.name
        cell.accessoryType = .disclosureIndicator
        self.updateTimeInCell(cell: cell, location: location)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            locations.remove(at: indexPath.row)
            tableView.deleteRows(at: [ indexPath as IndexPath ], with: .automatic)
        case .insert, .none:
            fatalError("not implemented")
        }
        self.delegate?.didChange(locations: locations)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let location = locations[sourceIndexPath.row]
        locations.remove(at: sourceIndexPath.row)
        locations.insert(location, at: destinationIndexPath.row)
        self.delegate?.didChange(locations: locations)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelect(location: locations[indexPath.row], index: indexPath.row)
    }
}
