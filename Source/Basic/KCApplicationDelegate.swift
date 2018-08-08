/**
 * @file	KCApplicationDelegate.swift
 * @brief	Define KCApplicationDelegate protocol
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import Foundation

#if os(OSX)
open class KCApplicationDelegage: NSObject, NSApplicationDelegate {
}
#else
open class AppDelegate: UIResponder, UIApplicationDelegate {
}
#endif

