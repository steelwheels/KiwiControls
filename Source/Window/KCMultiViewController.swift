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
	private var mIndexTable:		Dictionary<String, Int> = [:]	/* name -> index */
	private var mContentViewControllers:	Array<KCSingleViewController> = [] /* index -> view */
	private var mViewStack:			CNStack = CNStack<Int>()

	public var console 			= CNFileConsole()

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	open override func viewDidLoad() {
		super.viewDidLoad()
		showTabBar(visible:false)
	}

	public func check(name nm: String) -> Bool {
		if let _ = mIndexTable[nm] {
			return true
		} else {
			return false
		}
	}

	public func add(name nm: String, viewController vcont: KCSingleViewController) {
		if let curidx = mIndexTable[nm] {
			/* Overeite index table */
			mContentViewControllers[curidx] = vcont
		} else {
			/* Add the view to index table */
			let index = mContentViewControllers.count
			mIndexTable[nm] = index
			mContentViewControllers.append(vcont)
		}
		/* Add view to controller */
		#if os(OSX)
			let item = NSTabViewItem(identifier: nm)
			item.viewController = vcont
			self.addTabViewItem(item)
		#else
			self.setViewControllers(mContentViewControllers, animated: false)
		#endif
	}

	public func pushViewController(byName name: String) -> Bool {
		if let index = mIndexTable[name] {
			/* Push current index */
			mViewStack.push(index)
			/* Switch view */
			switchView(index: index)
			return true
		} else {
			CNLog(type: .Error, message: "No view controller named \(name)", place: #file)
			return false
		}
	}
	
	public func popViewController() -> Bool {
		if let _ = mViewStack.pop() {
			if let index = mViewStack.peek() {
				/* Switch view */
				switchView(index: index)
				return true
			}
		}
		return false
	}

	private func switchView(index idx: Int){
		#if os(OSX)
			self.selectedTabViewItemIndex = idx
		#else
			self.selectedIndex = idx
		#endif
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


