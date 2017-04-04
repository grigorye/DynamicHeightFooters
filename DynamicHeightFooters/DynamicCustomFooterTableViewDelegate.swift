//
//  DynamicCustomFooterTableViewDelegate.swift
//  DynamicHeightFooters
//
//  Created by Grigorii Entin on 04/04/2017.
//  Copyright © 2017 Grigory Entin. All rights reserved.
//

import UIKit

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
