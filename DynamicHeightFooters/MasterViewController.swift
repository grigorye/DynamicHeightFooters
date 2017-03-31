//
//  MasterViewController.swift
//  DynamicHeightFooters
//
//  Created by Grigorii Entin on 28/03/2017.
//  Copyright © 2017 Grigory Entin. All rights reserved.
//

import UIKit

var customCellsEnabled = false
var lineBreakMode: NSLineBreakMode = .byWordWrapping //!!!
var estimatedHeight: CGFloat = 2.0 //!!!
var estimatedRowHeight: CGFloat {
	return estimatedHeight
}

class CustomTableViewCell : UITableViewCell {
    
    @IBOutlet var customTitleLabel: UILabel!
    
}

class CustomHeaderFooterView : UITableViewHeaderFooterView {

    var customTitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 30)
        $0.lineBreakMode = lineBreakMode
        return $0
    } (UILabel())
    
    func prepareForUse() {
        textLabel!.isHidden = true
        contentView.addSubview(customTitleLabel)
		assert(preservesSuperviewLayoutMargins)
		assert(contentView.preservesSuperviewLayoutMargins)
        NSLayoutConstraint.activate({
			let otherItemsAndAttirbutes: [(item: Any, attribute: NSLayoutAttribute)] = [
				(layoutMarginsGuide, .trailing), //!!!
                (layoutMarginsGuide, .leading), //!!!
                (contentView, .topMargin), //!!!
                (contentView, .bottomMargin) //!!!
            ]
            return otherItemsAndAttirbutes.map {
                NSLayoutConstraint(item: customTitleLabel, attribute: $0.attribute, relatedBy: .equal, toItem: $0.item, attribute: $0.attribute, multiplier: 1, constant: 0)
            }
        }())
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepareForUse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareForUse()
    }
    
}

class TableViewDataSource : NSObject, UITableViewDataSource {
    
    var headersEnabled = true
    var footersEnabled = true
    
    var numberOfSections: Int = 100
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if customCellsEnabled {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
            let section = indexPath.section
            let text = ((0...section).map {"\($0)-s\(section)"}).joined(separator: "\n")
            cell.customTitleLabel.text = text
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.detailTextLabel!.text = "s\(indexPath.section)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard footersEnabled else {
            return nil
        }
        let text = ((0...section).map {"f\(section)-\($0)"}).joined(separator: "\n")
        return /*"The quick brown fox jumps over the lazy dog" + */text
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard headersEnabled else {
            return nil
        }
        let text = ((0...section).map {"h\(section)-\($0)"}).joined(separator: "\n")
        return /*"The quick brown fox jumps over the lazy dog" + */text
    }
    
}

class DynamicCustomFooterTableViewDelegate : NSObject, UITableViewDelegate {
    
    func prepare(_ tableView: UITableView) {
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Footer")
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer")! as! CustomHeaderFooterView
        let title = tableView.dataSource?.tableView?(tableView, titleForFooterInSection: section)
        headerFooterView.customTitleLabel.text = title
        return headerFooterView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")! as! CustomHeaderFooterView
        let title = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
        headerFooterView.customTitleLabel.text = title
        return headerFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let dataSource = tableView.dataSource! as! TableViewDataSource
        guard dataSource.footersEnabled else {
            return 0
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dataSource = tableView.dataSource! as! TableViewDataSource
        guard dataSource.headersEnabled else {
            return 0
        }
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard customCellsEnabled else {
            return 44 ///!!!
        }
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard customCellsEnabled else {
            return 0
        }
		guard 1 <= estimatedRowHeight else {
			return 0
		}
		guard 2 < estimatedRowHeight else {
			return 2
		}
		return estimatedRowHeight //!!!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let dataSource = tableView.dataSource! as! TableViewDataSource
        guard dataSource.footersEnabled else {
            return 0
        }
        return estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let dataSource = tableView.dataSource! as! TableViewDataSource
        guard dataSource.headersEnabled else {
            return 0
        }
        return estimatedHeight
    }

}

class DynamicStandardFooterTableViewDelegate : NSObject, UITableViewDelegate {
    
    func prepare(_ tableView: UITableView) {
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Footer")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer")
        return headerFooterView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        return headerFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let dataSource = tableView.dataSource! as! TableViewDataSource
        return dataSource.footersEnabled ? estimatedHeight : 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let dataSource = tableView.dataSource! as! TableViewDataSource
        return dataSource.headersEnabled ? estimatedHeight : 0
    }
    
}

class MasterViewController: UITableViewController {

    enum DelegateKind {
        enum DynamicSubKind {
            case custom
            case standard
        }

        case none
        case viewController
        case dynamic(subkind: DynamicSubKind)
    }
    
    static let delegateKind: DelegateKind = .dynamic(subkind: .custom)

    lazy var tableViewDelegate: UITableViewDelegate? = {
        switch delegateKind {
        case .none:
            return nil
        case .viewController:
            return self
        case .dynamic(let dynamicSubkind):
            let tableView = self.tableView!
            switch dynamicSubkind {
            case .custom:
                return {
                    $0.prepare(tableView)
                    return $0
                }(DynamicCustomFooterTableViewDelegate())
            case .standard:
                return {
                    $0.prepare(tableView)
                    return $0
                }(DynamicStandardFooterTableViewDelegate())
            }
        }
    }()

    let tableViewDataSource = TableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.reloadData()
    }
    
    // MARK: -
    
    @IBOutlet var customCellsBarItem: UIBarButtonItem!
    
    func updateCustomCellsBarItem() {
        customCellsBarItem.title = "Cust. Cells: " + (customCellsEnabled ? "ON" : "OFF")
    }
    @IBAction func toggleCustomCells() {
        customCellsEnabled = !customCellsEnabled
        updateCustomCellsBarItem()
        tableView.reloadData()
    }
    
    // MARK: -
    
    @IBOutlet var footersBarItem: UIBarButtonItem!
    
    func updateFootersBarItem() {
        footersBarItem.title = "Footers: " + (tableViewDataSource.footersEnabled ? "ON" : "OFF")
    }
    @IBAction func toggleFooters() {
        tableViewDataSource.footersEnabled = !tableViewDataSource.footersEnabled
        updateFootersBarItem()
        tableView.reloadData()
    }
    
    // MARK: -
    
    @IBOutlet var headersBarItem: UIBarButtonItem!
    
    func updateHeadersBarItem() {
        headersBarItem.title = "Headers: " + (tableViewDataSource.headersEnabled ? "ON" : "OFF")
    }
    @IBAction func toggleHeaders() {
        tableViewDataSource.headersEnabled = !tableViewDataSource.headersEnabled
        updateHeadersBarItem()
        tableView.reloadData()
    }
    
    // MARK: -
    
    @IBOutlet var lineBreakModeItem: UIBarButtonItem!
    
    func updateLineBreakModeItem() {
        lineBreakModeItem.title = {
            switch lineBreakMode {
            case .byWordWrapping:
                return "byWordWrapping"
            case .byTruncatingTail:
                return "byTruncatingTail"
            default:
                fatalError()
            }
        }()
    }
    
    @IBAction func toggleLineBreakMode() {
        lineBreakMode = {
            switch lineBreakMode {
            case .byWordWrapping:
                return .byTruncatingTail
            case .byTruncatingTail:
                return .byWordWrapping
            default:
                fatalError()
            }
        }()
        updateLineBreakModeItem()
        tableView.reloadData()
    }
    
    // MARK: -
    
    @IBOutlet var estimatedHeightStepper: UIStepper!
    @IBOutlet var estimatedHeightBarItem: UIBarButtonItem!

    func updateEstimatedHeightBarItem() {
        estimatedHeightBarItem.title = "\(estimatedHeight)"
    }
    
    @IBAction func estimatedHeightStepperValueChanged() {
        estimatedHeight = CGFloat(estimatedHeightStepper.value)
        updateEstimatedHeightBarItem()
        tableView.reloadData()
    }
}
