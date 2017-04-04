//
//  MasterViewController.swift
//  DynamicHeightFooters
//
//  Created by Grigorii Entin on 28/03/2017.
//  Copyright © 2017 Grigory Entin. All rights reserved.
//

import UIKit

typealias L = Localized

enum DelegateKind {
    enum DynamicSubKind {
        case custom
        case standard
    }
    
    case none
    case viewController
    case dynamic(subkind: DynamicSubKind)
}

class MasterViewController: UITableViewController {

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
        updateIncludeMarginsBarItem()
        updateDelegateKindBarItem()
        updateFootersBarItem()
        updateHeadersBarItem()
        updateCustomCellsBarItem()
        updateEstimatedHeightBarItem()
        updateEstimatedHeightStepper()
        updateHeaderTopMarginBarItem()
        updateHeaderTopMarginStepper()
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
    
    @IBOutlet var includeMarginsBarButtonItem: UIBarButtonItem!
    
    func updateIncludeMarginsBarItem() {
        (includeMarginsBarButtonItem.customView as! UIButton).isSelected = !excludeMarginsFromHeightEstimate
    }
    
    @IBAction func toggleIncludeMargins() {
        excludeMarginsFromHeightEstimate = !excludeMarginsFromHeightEstimate
        updateIncludeMarginsBarItem()
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
        estimatedHeightBarItem.title = "E:\(Int(estimatedHeight))"
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
    
    @IBOutlet var headerTopMarginStepper: UIStepper!
    @IBOutlet var headerTopMarginBarItem: UIBarButtonItem!
    
    func updateHeaderTopMarginBarItem() {
        headerTopMarginBarItem.title = "M:\(Int(headerTopMargin))"
    }
    
    func updateHeaderTopMarginStepper() {
        headerTopMarginStepper.value = Double(headerTopMargin)
    }
    
    @IBAction func headerTopMarginStepperValueChanged() {
        headerTopMargin = CGFloat(headerTopMarginStepper.value)
        updateHeaderTopMarginBarItem()
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
        case .none:
            delegateKind = .viewController
        case .viewController:
            delegateKind = .dynamic(subkind: .custom)
        case .dynamic(subkind: .custom):
            delegateKind = .dynamic(subkind: .standard)
        case .dynamic(subkind: .standard):
            delegateKind = .none
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard customCellsEnabled else {
            return 44 //!!!
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
}
