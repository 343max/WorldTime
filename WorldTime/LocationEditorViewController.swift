//
//  LocationEditorViewController.swift
//  WorldTime
//
//  Created by Max von Webel on 24.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

class LocationEditorViewController: UIViewController {
    var location: Location! {
        didSet {
            if isViewLoaded() {
                updateLocation(location)
            }
        }
    }

    @IBOutlet weak var locationNameTextField: UITextField!

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
    }
    
    @IBAction func tappedPickTimeZone(sender: AnyObject) {
        let timeZonePicker = TimeZonePicker(timeZone: location.timeZone)
        timeZonePicker.delegate = self
        let navigationController = UINavigationController(rootViewController: timeZonePicker)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
}

extension LocationEditorViewController: TimeZonePickerDelegate {
    func timeZonePicker(timeZonePicker: TimeZonePicker, didSelectTimeZone timeZone: NSTimeZone) {
        location.timeZone = timeZone
    }
}