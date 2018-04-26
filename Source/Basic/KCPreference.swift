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

public class KCPreference
{
	private static var 	mShared: KCPreference? = nil
	public static var	shared: KCPreference {
		get {
			if let obj = mShared {
				return obj
			} else {
				let newobj = KCPreference()
				mShared = newobj
				return newobj
			}
		}
	}

	public var terminalPreference:	KCTerminalPreference

	public init(){
		terminalPreference = KCTerminalPreference()
	}
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

	public var cursorAttributes: Dictionary<NSAttributedStringKey, Any> {
		get {
			return [
				.font		: font,
				.foregroundColor: backgroundColor,
				.backgroundColor: standardTextColor
			]
		}
	}

	public var standardAttribute: Dictionary<NSAttributedStringKey, Any> {
		get {
			return [
				.font		: font,
				.foregroundColor: standardTextColor,
				.backgroundColor: backgroundColor
			]
		}
	}

	public var errorAttribute: Dictionary<NSAttributedStringKey, Any> {
		get {
			return [
				.font		: font,
				.foregroundColor: errorTextColor,
				.backgroundColor: backgroundColor
			]
		}
	}
}

