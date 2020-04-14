/**
 * @file	KCViewControlEvent.swift
 * @brief	Define KCViewControlEvent class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

public enum KCViewControlEvent {
	case none
	case updateWindowSize
}

public protocol KCViewControlEventReceiver {
	func updateWindowSize()
}

extension KCResponder {
	func notify(viewControlEvent event: KCViewControlEvent) {
		var responder: KCResponder? = self
		while responder != nil {
			if let receiver = responder as? KCViewControlEventReceiver {
				switch event {
				case .none:
					break
				case .updateWindowSize:
					receiver.updateWindowSize()
				}
			}
			responder = responder?.next
		}
	}
}