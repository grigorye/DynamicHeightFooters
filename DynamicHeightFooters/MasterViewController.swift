//
//  MasterViewController.swift
//  DynamicHeightFooters
//
//  Created by Grigorii Entin on 28/03/2017.
//  Copyright © 2017 Grigory Entin. All rights reserved.
//

import UIKit

class CustomFooterView : UITableViewHeaderFooterView {

    var customTitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 30)
        return $0
    } (UILabel())
    
    func prepareForUse() {
        textLabel!.isHidden = true
        contentView.addSubview(customTitleLabel)
        NSLayoutConstraint.activate({
            let attributes: [NSLayoutAttribute] = [
                .trailingMargin,
                .leadingMargin,
                .topMargin,
                .bottomMargin
            ]
            return attributes.map {
                NSLayoutConstraint(item: customTitleLabel, attribute: $0, relatedBy: .equal, toItem: contentView, attribute: $0, multiplier: 1, constant: 0)
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
    
    var numberOfSections: Int = 100
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = "Section \(indexPath.section)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let text = ((0..<section).map {"\($0)"}).joined(separator: "\n")
        return text
    }
}

class DynamicCustomFooterTableViewDelegate : NSObject, UITableViewDelegate {
    
    func prepare(_ tableView: UITableView) {
        tableView.register(CustomFooterView.self, forHeaderFooterViewReuseIdentifier: "Footer")
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer")! as! CustomFooterView
        let title = tableView.dataSource?.tableView?(tableView, titleForFooterInSection: section)
        footerView.customTitleLabel.text = title
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
}

class DynamicStandardFooterTableViewDelegate : NSObject, UITableViewDelegate {
    
    func prepare(_ tableView: UITableView) {
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Footer")
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer")
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 30
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
    
}
