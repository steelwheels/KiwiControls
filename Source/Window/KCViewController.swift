/**
 * @file	KCViewController.swift
 * @brief	Define KCViewController class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

#if os(iOS)
	public typealias KCViewController = UIViewController
#else
	public typealias KCViewController = NSViewController
#endif

public extension KCViewController
{
	public class func entireFrame(viewController vcont: KCViewController) -> KCRect {
		#if os(OSX)
			let result: KCRect
			if let window = vcont.view.window {
				result = window.entireFrame
			} else {
				NSLog("\(#function) [Error] No window")
				result = KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
			}
		#else
			let result = vcont.view.frame
		NSLog("\(#function) : vcont.view.frame = \(result)")
		#endif
		return result
	}

	public class func safeAreaInsets(viewController vcont: KCViewController) -> KCEdgeInsets {
		let space = KCPreference.shared.layoutPreference.spacing
		#if os(OSX)
			let result = KCEdgeInsets(top: space, left: space, bottom: space, right: space)
		#else
			#if os(iOS)
				let topmargin: CGFloat
				if KCPreference.shared.layoutPreference.isPortrait {
					topmargin =  44.0 - space
				} else {
					topmargin =  0.0
				}
			#else
				let topmargin: CGFloat = 0
			#endif
			let insets = vcont.view.safeAreaInsets
			let result = KCEdgeInsets(top:    insets.top    + topmargin + space,
						  left:   insets.left   + space,
						  bottom: insets.bottom + space,
						  right:  insets.right  + space)
		#endif
		return result
	}

	public class func safeFrame(viewController vcont: KCViewController) -> KCRect {
		let frame = entireFrame(viewController: vcont)
		let inset = safeAreaInsets(viewController: vcont)
		return KCEdgeInsetsInsetRect(frame, inset)
	}

	public class func loadViewController(name nibname: String) -> KCViewController
	{
		let bundle : Bundle = Bundle(for: KCView.self) ;
		#if os(iOS)
			let nib = UINib(nibName: nibname, bundle: bundle)
			let controllers = nib.instantiate(withOwner: nil, options: nil)
			for i in 0..<controllers.count {
				if let controller = controllers[i] as? KCViewController {
					return controller ;
				}
			}
		#else
			if let nib = NSNib(nibNamed: NSNib.Name(rawValue: nibname), bundle: bundle) {
				var controllersp : NSArray? = NSArray()
				if(nib.instantiate(withOwner: nil, topLevelObjects: &controllersp)){
					if let controllers = controllersp {
						for i in 0..<controllers.count {
							if let controller = controllers[i] as? KCViewController {
								return controller
							}
						}
					}
				}
			}
		#endif
		fatalError("Failed to load " + nibname)
	}

	public func alert(error err: NSError){
		let _ = KCAlert.runModal(error: err, in: self)
	}
}

