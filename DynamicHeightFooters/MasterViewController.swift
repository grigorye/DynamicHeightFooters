//
//  MasterViewController.swift
//  DynamicHeightFooters
//
//  Created by Grigorii Entin on 28/03/2017.
//  Copyright © 2017 Grigory Entin. All rights reserved.
//

import UIKit

class FooterView : UITableViewHeaderFooterView {
    
    var label = UILabel()
    
    func embedLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 30)
        #if false
        let contentView = self
        #endif
        contentView.addSubview(label)
        NSLayoutConstraint.activate({
            let attributes: [NSLayoutAttribute] = [
                .trailingMargin,
                .leadingMargin,
                .topMargin,
                .bottomMargin
            ]
            return attributes.map {
                NSLayoutConstraint(item: label, attribute: $0, relatedBy: .equal, toItem: contentView, attribute: $0, multiplier: 1, constant: 0)
            }
        }())
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        embedLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        embedLabel()
    }
}

class MasterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FooterView.self, forHeaderFooterViewReuseIdentifier: "Footer")
        #if false
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionFooterHeight = 30
        #endif
    }

    var numberOfSections: Int = 100
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel!.text = "Section \(indexPath.section)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer")! as! FooterView
        let text = ((0..<section).map {"\($0)"}).joined(separator: "\n")
        footerView.label.text = text
        return footerView
    }

    #if true
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    #endif
    
}
