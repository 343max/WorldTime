//
//  TimeZonePickerViewController.swift
//  WorldTime
//
//  Created by Max von Webel on 29.11.15.
//  Copyright © 2015 Max von Webel. All rights reserved.
//

import UIKit

protocol TimeZonePickerDelegate: class {
    func timeZonePicker(timeZonePicker: TimeZonePicker, didSelectTimeZone timeZone: NSTimeZone)
}

extension NSTimeZone {
    var pseudoCleanedName: String {
        get {
            return String(name.characters.map({ $0 == "_" ? " " : $0 }))
        }
    }

    var pseudoLocalizedName: String {
        get {
            let parts = self.pseudoCleanedName.characters.split{ $0 == "/" }.map(String.init)
            if parts.count == 1 {
                return parts[0]
            } else {
                let reverse = Array(parts.reverse())
                return "\(reverse[0]), \(reverse[1])"
            }
        }
    }
}

class TimeZoneDataSource: NSObject, UITableViewDataSource {
    let reuseIdentifier = "Cell"
    let locale: NSLocale
    let timeZones: [NSTimeZone]

    var filteredTimeZones: [NSTimeZone]
    var activeTimeZone: NSTimeZone?

    init(locale: NSLocale, activeTimeZone: NSTimeZone?) {
        self.locale = locale
        self.activeTimeZone = activeTimeZone
        timeZones = NSTimeZone.knownTimeZoneNames().map() { NSTimeZone(name: $0)! }
        filteredTimeZones = timeZones
        super.init()
    }

    func filter(needle: String) {
        switch needle.characters.count {
        case 0:
            filteredTimeZones = timeZones
        default:
            filteredTimeZones = timeZones.filter { $0.pseudoCleanedName.localizedStandardContainsString(needle) }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTimeZones.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) ?? UITableViewCell(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        let timeZone = filteredTimeZones[indexPath.row]
        cell.textLabel?.text = timeZone.pseudoLocalizedName
        cell.detailTextLabel?.text = timeZone.localizedName(.Standard, locale: locale)
        cell.accessoryType = timeZone == activeTimeZone ? .Checkmark : .None
        return cell
    }
}

class TimeZonePicker: UIViewController {
    let searchBar = UISearchBar(frame: CGRect.zero)
    let dataSource: TimeZoneDataSource
    var tableView: UITableView!
    weak var delegate: TimeZonePickerDelegate?

    init(timeZone: NSTimeZone?) {
        dataSource = TimeZoneDataSource(locale: NSLocale.currentLocale(), activeTimeZone: timeZone)
        super.init(nibName: nil, bundle: nil)

        searchBar.sizeToFit()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        self.navigationItem.prompt = NSLocalizedString("Pick Time Zone", comment: "Time Zone Picker Prompt")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "tappedCancel:")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tappedCancel(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.keyboardDismissMode = .OnDrag

        if let timeZone = self.dataSource.activeTimeZone {
            if let index = dataSource.timeZones.indexOf(timeZone) {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
            }
        }

        view.addSubview(tableView)
        self.tableView = tableView
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
}

extension TimeZonePicker: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark

        let timeZone = dataSource.filteredTimeZones[indexPath.row]

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.delegate?.timeZonePicker(self, didSelectTimeZone: timeZone)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension TimeZonePicker: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.filter(searchText)
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
