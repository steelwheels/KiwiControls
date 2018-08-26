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

	/* This must be called after viewWillAppear */
	public class func safeArea(viewController vcont: KCViewController) -> KCRect {
		var result: KCRect
		#if os(OSX)
			if let window = vcont.view.window {
				result = window.rootFrame
			} else {
				NSLog("[Error] No window")
				let org  = KCPoint(x: 0.0, y: 0.0)
				let size = KCSize(width: 720.0, height: 480.0)
				result = KCRect(origin: org, size: size)
			}
		#else
			let entine  = vcont.view.frame
			let inset   = vcont.view.safeAreaInsets
			result = UIEdgeInsetsInsetRect(entine, inset)		
			//NSLog("safeArea = \(result)")
		#endif
		return result
	}
}

