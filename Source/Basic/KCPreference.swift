/**
 * @file	KCPreference.swift
 * @brief	Define KCPreference class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData
import Foundation

public class KCConfig: CNConfig {
	
}

public class KCLayoutPreference
{
	public var spacing: CGFloat		= 8.0

	public var backgroundColor: KCColor	= KCColor.white

	#if os(iOS)
	public var isPortrait: Bool {
		get {
			return UIApplication.shared.statusBarOrientation.isPortrait
		}
	}
	#endif
}

public class KCTerminalPreference
{
	public var	font:			KCFont
	public var	standardTextColor:	KCColor
	public var	errorTextColor:		KCColor
	public var	backgroundColor:	KCColor

	public init() {
		font			= KCFont(name: "Menlo", size: 12.0)!
		standardTextColor	= KCColor.green
		errorTextColor		= KCColor.red
		backgroundColor		= KCColor.black
	}

	public var cursorAttributes: Dictionary<NSAttributedString.Key, Any> {
		get {
			return [
				.font		: font,
				.foregroundColor: backgroundColor,
				.backgroundColor: standardTextColor
			]
		}
	}

	public var standardAttribute: Dictionary<NSAttributedString.Key, Any> {
		get {
			return [
				.font		: font,
				.foregroundColor: standardTextColor,
				.backgroundColor: backgroundColor
			]
		}
	}

	public var errorAttribute: Dictionary<NSAttributedString.Key, Any> {
		get {
			return [
				.font		: font,
				.foregroundColor: errorTextColor,
				.backgroundColor: backgroundColor
			]
		}
	}
}

extension CNPreference
{
	public var layoutPreference: KCLayoutPreference { get {
		return get(name: "system", allocator: {
			() -> KCLayoutPreference in return KCLayoutPreference()
		})
	}}

	public var terminalPreference: KCTerminalPreference { get {
		return get(name: "system", allocator: {
			() -> KCTerminalPreference in return KCTerminalPreference()
		})
	}}

}

private var sDidSetupped: Bool = false

public func KCSetupPreference(config conf: KCConfig)
{
	/* Skip setup if it already setupped */
	if sDidSetupped {
		return
	} else {
		sDidSetupped = true
	}
	/* Setup super class */
	CNSetupPreference(config: conf)
}


