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
	public typealias KCViewControllerBase = UIViewController
#else
	public typealias KCViewControllerBase = NSViewController
#endif

open class KCViewController : KCViewControllerBase
{	
	public class func loadViewController(name nibname: String) -> KCViewController
	{
		let bundle : Bundle = Bundle(for: KCViewController.self) ;
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

	public func contentsSize() -> KCSize {
		return KCViewController.contentSize(viewController: self)
	}

	public func alert(error err: NSError){
		let _ = KCAlert.runModal(error: err, in: self)
	}

	public class func contentSize(viewController vcont: KCViewControllerBase) -> KCSize {
		#if os(OSX)
		let contentsize: KCSize
		if let window = vcont.view.window {
			contentsize = window.rootFrame.size
		} else {
			NSLog("[Error] No window")
			contentsize = KCSize(width: 720.0, height: 480.0)
		}
		#else
		let contentsize = vcont.preferredContentSize
		#endif
		return contentsize
	}
}

