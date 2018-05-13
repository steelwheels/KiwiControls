/**
 * @file	KCApplicationDelegate.swift
 * @brief	Define KCApplicationDelegate protocol
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
	public typealias KCApplicationDelegate = NSApplicationDelegate
#else
	import UIKit
	public typealias KCApplicationDelegate = UIApplicationDelegate
#endif
import Foundation

