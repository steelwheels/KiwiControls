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

open class KCMultiViewController : KCMultiViewControllerBase, KCWindowDelegate
{
	private var mViewStack:		CNStack<KCViewController> = CNStack()
	private var mConsole:		CNConsole? = nil
	private var mContentSize:	KCSize = KCSize.zero

	/*
	#if os(OSX)

	private var mPickerView:	KCDocumentPickerViewController? = nil
	#endif
*/

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public func set(console cons: CNConsole?){
		mConsole = cons
	}

	#if os(OSX)
	public var contentSize: KCSize {
		get { return mContentSize }
	}
	#endif

	public var console: CNConsole? {
		get { return mConsole }
	}

	open override func viewDidLoad() {
		CNLog(logLevel: .debug, message: "viewDidLoad")

		super.viewDidLoad()
		showTabBar(visible:false)

		/* Change window size */
		#if os(OSX)
			if let size = KCMultiViewController.preferenceWindowSize() {
				if let window = self.view.window {
					window.setContentSize(size)
					self.view.setFrameSize(size)
					self.view.setBoundsSize(size)
				} else {
					NSLog("No window")
				}
			}
		#endif

		/* Keep initial size */
		mContentSize = self.view.frame.size
	}

	#if os(OSX)
	open override func viewWillAppear() {
		super.viewWillAppear()
	}
	#endif

	#if os(OSX)
	open override func viewDidAppear() {
		super.viewDidAppear()
		if let win = self.view.window {
			win.delegate = self
		}
	}
	#endif

	#if os(OSX)
	public class func preferenceWindowSize() -> KCSize? {
		let result: KCSize?
		#if os(OSX)
			result = CNPreference.shared.windowPreference.mainWindowSize
		#else
			result = UIScreen.main.bounds.size
		#endif
		return result
	}
	#endif

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

	public func pushViewController(viewController view: KCViewController) {
		#if os(OSX)
			/* Keep current view */
			let orgview = currentViewController()
			/* Add new item */
			let idx   = mViewStack.count
			let ident = viewIndexToIdentifer(index: idx)
			let item  = NSTabViewItem(identifier: ident)
			item.viewController = view
			CNLog(logLevel: .debug, message: "pushViewController identifier: \"\(ident)\"")
			self.addTabViewItem(item)
			/* Suspend previous view */
			if let prevview = orgview as? KCSingleViewController {
				prevview.suspend()
			}
		#else
			let newctrls: Array<KCViewController>
			let idx: Int
			if let orgctrls = self.viewControllers {
				var ctrls = orgctrls
				idx 	 = orgctrls.count
				ctrls.append(view)
				newctrls = ctrls
			} else {
				newctrls = [view]
				idx      = 0
			}
			self.setViewControllers(newctrls, animated: false)
		#endif
		/* Switch to new view */
		switchView(index: idx)
	}

	public func popViewController() -> Bool {
		let orgcnt = mViewStack.count
		guard orgcnt > 1 else {
			CNLog(logLevel: .debug, message: "popViewController -> Failed")
			return false
		}
		/* Switch to previous view */
		let orgidx = orgcnt - 1
		let newidx = orgidx - 1
		switchView(index: newidx)
		/* Remove original view */
		removeTabViewItem(index: orgidx)
		/* Resume current view */
		if let curview = currentViewController() as? KCSingleViewController {
			curview.resume()
		}
		return true
	}

	private func removeTabViewItem(index idx: Int) {
		#if os(OSX)
			self.removeTabViewItem(self.tabViewItems[idx])
		#else
			if let orgctrls = self.viewControllers {
				var newctrls: Array<KCViewController> = []
				for i in 0..<idx {
					newctrls.append(orgctrls[i])
				}
				self.setViewControllers(newctrls, animated: false)
			}
		#endif
	}

	private func viewIndexToIdentifer(index idx: Int) -> String {
		return "view\(idx)"
	}

	private func switchView(index idx: Int){
		#if os(OSX)
			self.selectedTabViewItemIndex = idx
		#else
			self.selectedIndex = idx
		#endif
	}

	private func currentViewController() -> KCViewController? {
		#if os(OSX)
			let idx = self.selectedTabViewItemIndex
			if 0 <= idx && idx < self.tabViewItems.count {
				let item = self.tabViewItems[idx]
				return item.viewController
			} else {
				return nil
			}
		#else
			return super.selectedViewController
		#endif
	}
}

