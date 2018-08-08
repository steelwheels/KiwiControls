/**
 * @file	KCMultiViewController.swift
 * @brief	Define KCMultiViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(iOS)
import UIKit
#else
import Cocoa
#endif
import CoconutData

#if os(iOS)
	public typealias KCMultiViewControllerBase = UITabBarController
#else
	public typealias KCMultiViewControllerBase = NSTabViewController
#endif

open class KCMultiViewController : KCMultiViewControllerBase
{
	private var mIndexTable: Dictionary<String, Int> = [:]
	private var mContentViewControllers: Array<KCSingleViewController> = []

	public var console = CNFileConsole()

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	open override func viewDidLoad() {
		super.viewDidLoad()
		showTabBar(visible: false)
	}

	public func add(name nm: String, delegate dlg: KCSingleViewDelegate){
		if let vcont = KCViewController.loadViewController(name: "KCSingleViewController") as? KCSingleViewController {
			/* Setup root view. This must be done before adding view controller */
			vcont.setup(delegate: dlg, console: console)
			/* Add the view to index table */
			mIndexTable[nm] = mContentViewControllers.count
			mContentViewControllers.append(vcont)
			/* Add view to controller */
			#if os(OSX)
				let item = NSTabViewItem(identifier: nm)
				item.viewController = vcont
				self.addTabViewItem(item)
			#else
				self.setViewControllers(mContentViewControllers, animated: false)
			#endif
		} else {
			NSLog("No XIB for KCSingleViewController")
		}
	}

	public func showTabBar(visible vis: Bool){
		#if os(OSX)
			let style: NSTabViewController.TabStyle
			if vis {
				style = .segmentedControlOnTop
			} else {
				style = .unspecified
			}
			self.tabStyle = style
		#else
			self.tabBar.isHidden = !vis
		#endif
	}

	public func alert(error err: NSError){
		let _ = KCAlert.runModal(error: err, in: self)
	}
}


