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
	private var mIndexTable:	Dictionary<String, Int> = [:]	/* name -> index */
	private var mViewStack:		CNStack = CNStack<String>()	/* name */

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	open override func viewDidLoad() {
		super.viewDidLoad()
		showTabBar(visible:false)
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

	public func hasViewController(name nm: String) -> Bool {
		if let _ = mIndexTable[nm] {
			return true
		} else {
			return false
		}
	}

	public func add(name nm: String, viewController vcont: KCSingleViewController) {
		let index = numberOfViewControllers()
		#if os(OSX)
			let item = NSTabViewItem(identifier: nm)
			item.viewController = vcont
			self.addTabViewItem(item)
		#else
			var ctrls: Array<KCViewController>
			if let orgctrls = viewControllers {
				ctrls = orgctrls
				ctrls.append(vcont)
			} else {
				ctrls = [vcont]
			}
			setViewControllers(ctrls, animated: false)
		#endif
		mIndexTable[nm] = index
	}

	private func numberOfViewControllers() -> Int {
		#if os(OSX)
			return tabViewItems.count
		#else
			var result: Int
			if let ctrls = viewControllers {
				result = ctrls.count
			} else {
				result = 0
			}
			return result
		#endif
	}

	public func pushViewController(byName name: String) -> Bool {
		CNLog(type: .Normal, message: "pushViewController named: \"\(name)\"", place: #function)
		if let idx = mIndexTable[name] {
			mViewStack.push(name)
			switchView(index: idx)
			return true
		}
		CNLog(type: .Error, message: "No matched view", place: #function)
		return false
	}

	public func popViewController() -> Bool {
		if mViewStack.count > 1 {
			let _ = mViewStack.pop()
			if let name = mViewStack.peek() {
				if let idx = mIndexTable[name] {
					switchView(index: idx)
					return true
				}
			}
			CNLog(type: .Error, message: "Can not happen (2)", place: #function)
		}
		return false
	}

	public func replaceTopViewController(byName name: String) -> Bool {
		var oldname: String
		if let oname = mViewStack.pop() {
			oldname = oname
		} else {
			oldname = "<none>"
		}
		CNLog(type: .Normal, message: "replaceTopViewController named: \"\(oldname)\" -> \"\(name)\"", place: #function)
		return pushViewController(byName: name)
	}

	private func switchView(index idx: Int){
		CNLog(type: .Normal, message: "switchView: to \(idx)", place: #function)
		#if os(OSX)
			self.selectedTabViewItemIndex = idx
		#else
			self.selectedIndex = idx
		#endif
	}
}

