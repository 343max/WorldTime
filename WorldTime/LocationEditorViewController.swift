//
//  LocationEditorViewController.swift
//  WorldTime
//
//  Created by Max von Webel on 24.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

class LocationEditorViewController: UIViewController {
    var location: Location!

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

        locationNameTextField.text = location.name
    }
    
    @IBAction func tappedPickTimeZone(sender: AnyObject) {
        let timeZonePicker = TimeZonePickerViewController(location: location)
        let navigationController = UINavigationController(rootViewController: timeZonePicker)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
}
