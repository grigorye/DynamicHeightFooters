//
//  DynamicStandardFooterTableViewDelegate.swift
//  DynamicHeightFooters
//
//  Created by Grigorii Entin on 04/04/2017.
//  Copyright © 2017 Grigory Entin. All rights reserved.
//

import UIKit

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
