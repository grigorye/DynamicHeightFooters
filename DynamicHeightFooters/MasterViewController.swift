//
//  MasterViewController.swift
//  DynamicHeightFooters
//
//  Created by Grigorii Entin on 28/03/2017.
//  Copyright © 2017 Grigory Entin. All rights reserved.
//

import UIKit

private var customCellsEnabled = false

private var lineBreakMode: NSLineBreakMode = .byWordWrapping //!!!

private var estimatedHeight: CGFloat = 2.0 //!!!

private var estimatedRowHeight: CGFloat {
	return estimatedHeight
}

private let headerColor = UIColor.yellow
private let footerColor = UIColor.cyan

var _true = true
var _false = false

infix operator …

func …<T>(_ initialValue: T, initialize: (inout T) -> ()) -> T {
    var value = initialValue
    initialize(&value)
    return value
}

func …<T: AnyObject>(_ object: T, initialize: (T) -> ()) -> T {
    initialize(object)
    return object
}

typealias L = Localized

class CustomTableViewCell : UITableViewCell {
    
    @IBOutlet var customTitleLabel: UILabel!
    
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
    
    typealias _Self = DynamicCustomFooterTableViewDelegate

    static let verticalHeaderMargins: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    static let verticalFooterMargins: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    
    var minimumHeaderHeight: CGFloat {
        return _Self.verticalHeaderMargins.top + _Self.verticalHeaderMargins.bottom
    }
    var minimumFooterHeight: CGFloat {
        return _Self.verticalFooterMargins.top + _Self.verticalFooterMargins.bottom
    }
    
    class CustomHeaderFooterView : UITableViewHeaderFooterView {
        
        var customTitleLabel = UILabel() … {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 30)
            $0.lineBreakMode = lineBreakMode
        }
        
        func prepareForUse() {
            textLabel!.isHidden = true
            assert(preservesSuperviewLayoutMargins)
            assert(contentView.preservesSuperviewLayoutMargins)
            assert(self.translatesAutoresizingMaskIntoConstraints)
            assert(contentView.translatesAutoresizingMaskIntoConstraints)
            assert(contentView.autoresizesSubviews)
            let isHeader = (self.reuseIdentifier! == DynamicCustomFooterTableViewDelegate.ReuseIdentifiers.header)
            customTitleLabel.backgroundColor = isHeader ? headerColor : footerColor
            let embeddedView = customTitleLabel
            contentView.addSubview(embeddedView)
            contentView.layoutMargins = contentView.layoutMargins … {
                let verticalMargins = isHeader ? verticalHeaderMargins : verticalFooterMargins
                $0.top = verticalMargins.top
                $0.bottom = verticalMargins.bottom
            }
            let margins = contentView.layoutMarginsGuide
            let constraints = [
                margins.leadingAnchor.constraint(equalTo: embeddedView.leadingAnchor),
                margins.trailingAnchor.constraint(equalTo: embeddedView.trailingAnchor),
                embeddedView.topAnchor.constraint(equalTo: margins.topAnchor),
                margins.bottomAnchor.constraint(equalTo: embeddedView.bottomAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
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
    
    struct ReuseIdentifiers {
        static let header = "DCHeader"
        static let footer = "DCFooter"
    }
    
    func prepare(_ tableView: UITableView) {
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: ReuseIdentifiers.footer)
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: ReuseIdentifiers.header)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let dataSource = tableView.dataSource! as! TableViewDataSource
        guard dataSource.footersEnabled else {
            return nil
        }
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReuseIdentifiers.footer)! as! CustomHeaderFooterView
        let title = tableView.dataSource?.tableView?(tableView, titleForFooterInSection: section)
        headerFooterView.customTitleLabel.text = title
        return headerFooterView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dataSource = tableView.dataSource! as! TableViewDataSource
        guard dataSource.headersEnabled else {
            return nil
        }
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReuseIdentifiers.header)! as! CustomHeaderFooterView
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
            return 44 //!!!
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
        return (estimatedHeight + minimumFooterHeight)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let dataSource = tableView.dataSource! as! TableViewDataSource
        guard dataSource.headersEnabled else {
            return 0
        }
        return (estimatedHeight + minimumHeaderHeight)
    }

}

class DynamicStandardFooterTableViewDelegate : NSObject, UITableViewDelegate {
    
    struct ReuseIdentifiers {
        static let header = "DSHeader"
        static let footer = "DSFooter"
    }
    
    func prepare(_ tableView: UITableView) {
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: ReuseIdentifiers.footer)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: ReuseIdentifiers.header)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReuseIdentifiers.footer)
        return headerFooterView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReuseIdentifiers.header)
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
    
    func newTableViewDelegate() -> UITableViewDelegate? {
        switch delegateKind {
        case .none:
            return nil
        case .viewController:
            return self
        case .dynamic(let dynamicSubkind):
            let tableView = self.tableView!
            switch dynamicSubkind {
            case .custom:
                return DynamicCustomFooterTableViewDelegate() … {
                    $0.prepare(tableView)
                }
            case .standard:
                return DynamicStandardFooterTableViewDelegate() … {
                    $0.prepare(tableView)
                }
            }
        }
    }

    let tableViewDataSource = TableViewDataSource()
	lazy var tableViewDelegate: UITableViewDelegate? = self.newTableViewDelegate()
	
	func updateForTableViewDelegate() {
		tableView.delegate = tableViewDelegate
		tableView.reloadData()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDelegateKindBarItem()
		updateFootersBarItem()
		updateHeadersBarItem()
		updateCustomCellsBarItem()
        updateEstimatedHeightBarItem()
        updateEstimatedHeightStepper()
		tableView.dataSource = tableViewDataSource
		tableView.delegate = tableViewDelegate
    }
    
    // MARK: -
    
    @IBOutlet var customCellsBarItem: UIBarButtonItem!
    
    func updateCustomCellsBarItem() {
		(customCellsBarItem.customView as! UIButton).isSelected = customCellsEnabled
    }
	
    @IBAction func toggleCustomCells() {
        customCellsEnabled = !customCellsEnabled
        updateCustomCellsBarItem()
        tableView.reloadData()
    }
    
    // MARK: -
    
    @IBOutlet var footersBarItem: UIBarButtonItem!
    
    func updateFootersBarItem() {
		(footersBarItem.customView as! UIButton).isSelected = tableViewDataSource.footersEnabled
    }
	
    @IBAction func toggleFooters() {
        tableViewDataSource.footersEnabled = !tableViewDataSource.footersEnabled
        updateFootersBarItem()
        tableView.reloadData()
    }
    
    // MARK: -
    
    @IBOutlet var headersBarItem: UIBarButtonItem!
    
    func updateHeadersBarItem() {
		(headersBarItem.customView as! UIButton).isSelected = tableViewDataSource.headersEnabled
    }
    @IBAction func toggleHeaders() {
        tableViewDataSource.headersEnabled = !tableViewDataSource.headersEnabled
        updateHeadersBarItem()
        tableView.reloadData()
    }
    
    // MARK: -
    
    @IBOutlet var lineBreakModeItem: UIBarButtonItem!
    
    func updateLineBreakModeItem() {
		lineBreakModeItem.title = L.lineBreakModeBarItemTitle(for: lineBreakMode)
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
    
    func updateEstimatedHeightStepper() {
        estimatedHeightStepper.value = Double(estimatedHeight)
    }
    
    @IBAction func estimatedHeightStepperValueChanged() {
        estimatedHeight = CGFloat(estimatedHeightStepper.value)
        updateEstimatedHeightBarItem()
        tableView.reloadData()
    }
	
	// MARK: -

    var delegateKind: DelegateKind = _true ? .none : .dynamic(subkind: .custom)
    
	@IBOutlet var delegateKindBarItem: UIBarButtonItem!
	
	func updateDelegateKindBarItem() {
		delegateKindBarItem.title = L.delegateKindBarItemTitle(for: delegateKind)
	}
	
	@IBAction func toggleDelegateKind() {
		switch delegateKind {
        case .dynamic(_):
            delegateKind = .none
		case .viewController:
			delegateKind = .dynamic(subkind: .custom)
        case .none:
            delegateKind = .viewController
		}
		updateDelegateKindBarItem()
		tableViewDelegate = newTableViewDelegate()
		updateForTableViewDelegate()
	}
	
}

extension MasterViewController {
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerFooterView = view as! UITableViewHeaderFooterView
        headerFooterView.textLabel?.backgroundColor = headerColor
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let headerFooterView = view as! UITableViewHeaderFooterView
        headerFooterView.textLabel?.backgroundColor = footerColor
    }
    
}
