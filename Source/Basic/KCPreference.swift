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

public class KCWindowPreference
{
	public var spacing			: CGFloat
	public var backgroundColor		: KCColor
	#if os(OSX)
	public var mainWindowSize		: KCSize?
	#endif

	public init(){
		spacing			= 0.0
		backgroundColor		= KCColor.white
		#if os(OSX)
			mainWindowSize	= nil
		#endif
	}

	#if os(iOS)
	public var isPortrait: Bool {
		get {
			if let window = UIApplication.shared.windows.first {
				if let scene = window.windowScene {
					return scene.interfaceOrientation.isPortrait
				}
			}
			return true
		}
	}
	#endif
}

extension CNPreference
{
	public var windowPreference: KCWindowPreference { get {
		return get(name: "window", allocator: {
			() -> KCWindowPreference in return KCWindowPreference()
		})
	}}
}



