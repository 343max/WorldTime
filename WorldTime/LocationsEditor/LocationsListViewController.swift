// Copyright 2014-present Max von Webel. All Rights Reserved.

import UIKit

class LocationsListViewController: UIViewController {
    let dataSource = LocationsListDataSource()

    weak var tableView: UITableView!
    var minuteChangeNotifier: MinuteChangeNotifier?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = NSLocalizedString("World Time", comment: "nav bar title")

        dataSource.delegate = self

        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    @objc func addLocation(sender: AnyObject?) {
        let timeZonePicker = TimeZonePicker()
        timeZonePicker.delegate = self
        let navigationController = UINavigationController(rootViewController: timeZonePicker)
        present(navigationController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = dataSource
        tableView.delegate = dataSource

        view.addSubview(tableView)
        self.tableView = tableView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dataSource.locations = Location.fromDefaults()

        self.minuteChangeNotifier = MinuteChangeNotifier(delegate: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.minuteChangeNotifier = nil
    }
}

extension LocationsListViewController: LocationsListDataSourceDelegate {
    func didChange(locations: [Location]) {
        Location.toDefaults(locations: locations)
    }

    func didSelect(location: Location, index: Int) {
        let editorViewController = LocationEditorViewController.fromXib(location: location, index: index)
        editorViewController.delegate = self
        self.navigationController?.pushViewController(editorViewController, animated: true)
    }
}

extension LocationsListViewController: MinuteChangeNotifierDelegate {
    func minuteDidChange(notifier: MinuteChangeNotifier) {
        for cell in self.tableView.visibleCells {
            if let indexPath = self.tableView.indexPath(for: cell) {
                let location = dataSource.locations[indexPath.row]
                dataSource.updateTime(cell: cell, location: location)
            }
        }
    }
}

extension LocationsListViewController: LocationEditorDelegate {
    func locationEditorDidEditLocation(index: Int, newLocation: Location) {
        dataSource.update(location: newLocation, index: index, tableView: tableView)
    }
}

extension LocationsListViewController: TimeZonePickerDelegate {
    func timeZonePicker(_ timeZonePicker: TimeZonePicker, didSelect timeZone: TimeZone) {
        let location = Location(name: timeZone.pseudoLocalizedShortName, timeZone: timeZone)
        dataSource.add(location: location, tableView: tableView)
    }
}
