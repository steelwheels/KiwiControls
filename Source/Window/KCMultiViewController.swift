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
	private var mIndexTable: Dictionary<String, Int> = [:]	/* name -> index */
	private var mContentViewControllers: Array<KCSingleViewController> = []

	public var console = CNFileConsole()

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	open override func viewDidLoad() {
		super.viewDidLoad()
		showTabBar(visible:false)
	}

	public func add(name nm: String, viewController vcont: KCSingleViewController) -> Int {
		/* Add the view to index table */
		let index = mContentViewControllers.count
		mIndexTable[nm] = index
		mContentViewControllers.append(vcont)
		/* Add view to controller */
		#if os(OSX)
			let item = NSTabViewItem(identifier: nm)
			item.viewController = vcont
			self.addTabViewItem(item)
		#else
			self.setViewControllers(mContentViewControllers, animated: false)
		#endif
		return index
	}

	public func search(byName name: String) -> Int? {
		return mIndexTable[name]
	}

	public func select(byIndex index: Int) -> Bool {
		if 0<=index && index<mContentViewControllers.count {
			#if os(OSX)
				self.selectedTabViewItemIndex = index
			#else
				self.selectedIndex = index
			#endif
			return true
		} else {
			NSLog("\(#function) [Error] Invalid index: \(index)")
			return false
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
}


