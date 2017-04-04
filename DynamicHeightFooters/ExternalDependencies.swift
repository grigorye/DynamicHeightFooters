//
//  ExternalDependencies.swift
//  DynamicHeightFooters
//
//  Created by Grigorii Entin on 04/04/2017.
//  Copyright © 2017 Grigory Entin. All rights reserved.
//

import Foundation

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
