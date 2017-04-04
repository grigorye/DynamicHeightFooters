//
//  Localized.swift
//  DynamicHeightFooters
//
//  Created by Grigory Entin on 01.04.17.
//  Copyright © 2017 Grigory Entin. All rights reserved.
//

import UIKit
import Foundation

struct Localized {
}

extension Localized {
	
	static func lineBreakModeBarItemTitle(for lineBreakMode: NSLineBreakMode) -> String {
		return "LB:" + {
			switch lineBreakMode {
			case .byWordWrapping:
				return "WW"
			case .byTruncatingTail:
				return "TT"
			default:
				fatalError()
			}
		}()
	}
	
	static func delegateKindBarItemTitle(for delegateKind: MasterViewController.DelegateKind) -> String {
		return "DK:" + {
			switch delegateKind {
			case .none:
				return "-"
			case .dynamic(_):
				return "D"
            case .viewController:
                return "V"
			}
		}()
	}

}
