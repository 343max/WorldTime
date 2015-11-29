//
//  LocationEditorViewController.swift
//  WorldTime
//
//  Created by Max von Webel on 24.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

class TimeZoneDataSource: NSObject, UITableViewDataSource {
    let reuseIdentifier = "Cell"
    let locale: NSLocale
    let timeZones: [NSTimeZone]

    init(locale: NSLocale) {
        self.locale = locale
        self.timeZones = NSTimeZone.knownTimeZoneNames().map() { NSTimeZone(name: $0)! }
        super.init()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZones.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) ?? UITableViewCell(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        let timeZone = timeZones[indexPath.row]
        cell.textLabel?.text = timeZone.localizedName(.Standard, locale: locale)
        cell.detailTextLabel?.text = timeZone.name
        return cell
    }
}

class LocationEditorViewController: UIViewController {
    var location: Location!
    var dataSoure: TimeZoneDataSource!

    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var timeZoneTableView: UITableView!

    static func fromXib(location: Location) -> LocationEditorViewController {
        let storyboard = UIStoryboard(name: "LocationEditorViewController", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? LocationEditorViewController else {
            fatalError("no LocationEditorViewController")
        }
        viewController.location = location
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationNameTextField.text = location.name

        dataSoure = TimeZoneDataSource(locale: NSLocale.currentLocale())
        timeZoneTableView.dataSource = dataSoure
    }
}
