// Copyright 2014-present Max von Webel. All Rights Reserved.

import UIKit

protocol TimeZonePickerDelegate: class {
    func timeZonePicker(_ timeZonePicker: TimeZonePicker, didSelect timeZone: TimeZone)
}

extension TimeZone {
    var pseudoCleanedName: String {
        get {
            return String(identifier.map({ $0 == "_" ? " " : $0 }))
        }
    }

    var pseudoNameParts: [String] {
        return self.pseudoCleanedName.split{ $0 == "/" }.map(String.init)
    }

    var pseudoLocalizedName: String {
        get {
            return Array(self.pseudoNameParts.reversed()).joined(separator: ", ")
        }
    }

    var pseudoLocalizedShortName: String {
        return self.pseudoNameParts.last!
    }
}

class TimeZoneDataSource: NSObject, UITableViewDataSource {
    let reuseIdentifier = "Cell"
    let locale: Locale
    let timeZones: [TimeZone]

    var filteredTimeZones: [TimeZone]
    var activeTimeZone: TimeZone?

    init(locale: Locale, activeTimeZone: TimeZone?) {
        self.locale = locale
        self.activeTimeZone = activeTimeZone
        timeZones = TimeZone.knownTimeZoneIdentifiers.map() { TimeZone(identifier: $0)! }.sorted(by: { (a, b) -> Bool in
            if (a.secondsFromGMT() != b.secondsFromGMT()) {
                return a.secondsFromGMT() < b.secondsFromGMT()
            }
            
            return a.identifier < b.identifier
        })
        filteredTimeZones = timeZones
        super.init()
    }

    func filter(needle: String) {
        if needle.isEmpty {
            filteredTimeZones = timeZones
        } else {
            filteredTimeZones = timeZones.filter {
                $0.pseudoCleanedName.localizedStandardContains(needle) ||
                $0.localizedName(for: .standard, locale: locale)?.localizedStandardContains(needle) ?? false
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTimeZones.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        let timeZone = filteredTimeZones[indexPath.row]
        cell.textLabel?.text = timeZone.pseudoLocalizedName
        cell.detailTextLabel?.text = timeZone.localizedName(for: .standard, locale: locale)
        cell.accessoryType = timeZone == activeTimeZone ? .checkmark : .none
        return cell
    }
}

class TimeZonePicker: UIViewController {
    let searchBar = UISearchBar(frame: CGRect.zero)
    let dataSource: TimeZoneDataSource
    var tableView: UITableView!
    weak var delegate: TimeZonePickerDelegate?

    convenience init() {
        self.init(timeZone: nil)
    }

    init(timeZone: TimeZone?) {
        dataSource = TimeZoneDataSource(locale: Locale.current, activeTimeZone: timeZone)
        super.init(nibName: nil, bundle: nil)

        searchBar.sizeToFit()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        self.navigationItem.prompt = NSLocalizedString("Pick Time Zone", comment: "Time Zone Picker Prompt")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tappedCancel))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tappedCancel(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag

        if let timeZone = self.dataSource.activeTimeZone {
            if let index = dataSource.timeZones.index(of: timeZone) {
                let indexPath = IndexPath(row: index, section: 0)
                tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
            }
        }

        view.addSubview(tableView)
        self.tableView = tableView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
}

extension TimeZonePicker: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        cell?.accessoryType = .checkmark

        let timeZone = dataSource.filteredTimeZones[indexPath.row]

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.delegate?.timeZonePicker(self, didSelect: timeZone)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension TimeZonePicker: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.filter(needle: searchText)
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
