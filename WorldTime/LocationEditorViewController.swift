//
//  LocationEditorViewController.swift
//  WorldTime
//
//  Created by Max von Webel on 24.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

class LocationEditorViewController: UITableViewController {
    var location: Location! {
        didSet {
            if isViewLoaded() {
                updateLocation(location)
            }
        }
    }

    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var timeZoneCell: UITableViewCell!

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

        updateLocation(location)
    }

    func updateLocation(location: Location) {
        locationNameTextField.text = location.name
        timeZoneCell.textLabel?.text = location.timeZone.localizedName(.Standard, locale: NSLocale.currentLocale())
    }
}

extension LocationEditorViewController: TimeZonePickerDelegate {
    func timeZonePicker(timeZonePicker: TimeZonePicker, didSelectTimeZone timeZone: NSTimeZone) {
        location.timeZone = timeZone
    }
}

extension LocationEditorViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell == timeZoneCell {
            let timeZonePicker = TimeZonePicker(timeZone: location.timeZone)
            timeZonePicker.delegate = self
            let navigationController = UINavigationController(rootViewController: timeZonePicker)
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
}