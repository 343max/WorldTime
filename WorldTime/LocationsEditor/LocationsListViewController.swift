//
//  ViewController.swift
//  WorldTime
//
//  Created by Max von Webel on 21/09/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

import UIKit

class LocationsListViewController: UIViewController {
    let dataSource = LocationsListDataSource()

    weak var tableView: UITableView!
    var minuteChangeNotifier: MinuteChangeNotifier?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = NSLocalizedString("World Time", comment: "nav bar title")

        dataSource.delegate = self

        navigationItem.leftBarButtonItem = editButtonItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addLocation:")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    @objc func addLocation(sender: AnyObject?) {
        let timeZonePicker = TimeZonePicker()
        timeZonePicker.delegate = self
        let navigationController = UINavigationController(rootViewController: timeZonePicker)
        presentViewController(navigationController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        let tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tableView.dataSource = dataSource
        tableView.delegate = dataSource

        view.addSubview(tableView)
        self.tableView = tableView
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        dataSource.locations = Location.fromDefaults()

        self.minuteChangeNotifier = MinuteChangeNotifier(delegate: self)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        self.minuteChangeNotifier = nil
    }
}

extension LocationsListViewController: LocationsListDataSourceDelegate {
    func didChangeLocations(locations: [Location]) {
        Location.toDefaults(locations)
    }

    func didSelectLocation(location: Location, index: Int) {
        let editorViewController = LocationEditorViewController.fromXib(location, index: index)
        editorViewController.delegate = self
        self.navigationController?.pushViewController(editorViewController, animated: true)
    }
}

extension LocationsListViewController: MinuteChangeNotifierDelegate {
    func minuteDidChange(notifier: MinuteChangeNotifier) {
        for cell in self.tableView.visibleCells {
            if let indexPath = self.tableView.indexPathForCell(cell) {
                let location = dataSource.locations[indexPath.row]
                dataSource.updateTimeInCell(cell, location: location)
            }
        }
    }
}

extension LocationsListViewController: LocationEditorDelegate {
    func locationEditorDidEditLocation(index index: Int, newLocation: Location) {
        dataSource.updateLocation(newLocation, index: index, tableView: tableView)
    }
}

extension LocationsListViewController: TimeZonePickerDelegate {
    func timeZonePicker(timeZonePicker: TimeZonePicker, didSelectTimeZone timeZone: NSTimeZone) {
        let location = Location(name: timeZone.pseudoLocalizedShortName, timeZone: timeZone)
        dataSource.addLocation(location, tableView: tableView)
    }
}
