// Copyright 2014-present Max von Webel. All Rights Reserved.

import UIKit

protocol LocationEditorDelegate: class {
    func locationEditorDidEditLocation(index: Int, newLocation: Location)
}

class LocationEditorViewController: UITableViewController {
    var index = 0
    var location: Location! {
        didSet {
            self.delegate?.locationEditorDidEditLocation(index: index, newLocation: location)
            if isViewLoaded {
                update(location: location)
            }
        }
    }

    weak var delegate: LocationEditorDelegate?

    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var timeZoneCell: UITableViewCell!

    static func fromXib(location: Location, index: Int) -> LocationEditorViewController {
        let storyboard = UIStoryboard(name: "LocationEditorViewController", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? LocationEditorViewController else {
            fatalError("no LocationEditorViewController")
        }
        viewController.location = location
        viewController.index = index
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationNameTextField.delegate = self

        update(location: location)
    }

    func update(location: Location) {
        locationNameTextField.text = location.name
        timeZoneCell.textLabel?.text = location.timeZone.pseudoLocalizedName
        timeZoneCell.detailTextLabel?.text = location.timeZone.localizedName(for: .standard, locale: Locale.current)
    }
}

extension LocationEditorViewController: TimeZonePickerDelegate {
    func timeZonePicker(_ timeZonePicker: TimeZonePicker, didSelect timeZone: TimeZone) {
        location.timeZone = timeZone
    }
}

extension LocationEditorViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let name = textField.text, !name.isEmpty {
            self.location.name = name
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension LocationEditorViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        if cell == timeZoneCell {
            let timeZonePicker = TimeZonePicker(timeZone: location.timeZone)
            timeZonePicker.delegate = self
            let navigationController = UINavigationController(rootViewController: timeZonePicker)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
