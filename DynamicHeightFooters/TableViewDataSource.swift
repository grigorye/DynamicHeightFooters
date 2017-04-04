//
//  TableViewDataSource.swift
//  DynamicHeightFooters
//
//  Created by Grigorii Entin on 04/04/2017.
//  Copyright © 2017 Grigory Entin. All rights reserved.
//

import UIKit


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
