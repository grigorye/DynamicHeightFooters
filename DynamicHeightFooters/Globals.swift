//
//  Globals.swift
//  DynamicHeightFooters
//
//  Created by Grigorii Entin on 04/04/2017.
//  Copyright © 2017 Grigory Entin. All rights reserved.
//

import UIKit

var customCellsEnabled = false

var lineBreakMode: NSLineBreakMode = .byWordWrapping //!!!

var headerTopMargin: CGFloat = 8
var estimatedHeight: CGFloat = 2 //!!! Works even for `excludeMarginsForHeightEstimate = true`, if you constraint against exactly content view bounds (with no inset), not against margins.

var excludeMarginsFromHeightEstimate = false ///!!!

var estimatedRowHeight: CGFloat {
    return estimatedHeight
}

let headerColor = UIColor.yellow
let footerColor = UIColor.cyan
