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
			let idx   = mViewStack.count
			let ident = viewIndexToIdentifer(index: idx)
			let item  = NSTabViewItem(identifier: ident)
			item.viewController = view
			CNLog(logLevel: .debug, message: "pushViewController identifier: \"\(ident)\"")
			self.addTabViewItem(item)
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
			let item = self.tabViewItems[self.selectedTabViewItemIndex]
			return item.viewController
		#else
			return super.selectedViewController
		#endif
	}

	/*
	public func dump(to cons: CNConsole){
		cons.print(string: "multi-view: {\n")

		let stackdesc = "[" + mViewStack.peekAll().joined(separator: ",") + "]"
		cons.print(string: " stack: " + stackdesc + "\n")

		var indices: Array<String> = []
		for (key, value) in mIndexTable {
			indices.append("\(key):\(value)")
		}
		cons.print(string: " index: " + indices.joined(separator: ",") + "\n")

		cons.print(string: "}\n")
	}

	public func selectFile(title ttext: String, fileExtensions exts: [String], loaderFunction loader: @escaping (_ url: URL) -> Void) {
		#if os(OSX)
			if let url = URL.openPanel(title: ttext, selection: .SelectFile, fileTypes: exts) {
				loader(url)
			}
		#else
			let picker: KCDocumentPickerViewController
			if let p = mPickerView {
				picker = p
			} else {
				picker = KCDocumentPickerViewController(parentViewController: self)
				mPickerView = picker
			}
			picker.setLoaderFunction(loader: .url({
				(_ url: URL) -> Void in
				loader(url)
			}))
			let manager = CNDocumentTypeManager.shared
			let utis    = manager.UTIs(forExtensions: exts)
			picker.openPicker(UTIs: utis)
		#endif
	}

	public func selectViewFile(title ttext: String, fileExtensions exts: [String], loaderFunction loader: @escaping (_ url: URL) -> String?) {
		#if os(OSX)
			if let url = URL.openPanel(title: ttext, selection: .SelectFile, fileTypes: exts) {
				if let viewname = loader(url) {
					let _ = self.pushViewController(byName: viewname)
				}
			}
		#else
			let picker: KCDocumentPickerViewController
			if let p = mPickerView {
				picker = p
			} else {
				picker = KCDocumentPickerViewController(parentViewController: self)
				mPickerView = picker
			}
			picker.setLoaderFunction(loader: .view({
				(_ url: URL) -> String? in
				return loader(url)
			}))
			let manager = CNDocumentTypeManager.shared
			let utis = manager.UTIs(forExtensions: exts)
			picker.openPicker(UTIs: utis)
		#endif
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
		CNLog(logLevel: .debug, message: "pushViewController named: \"\(name)\"")
		if let idx = mIndexTable[name] {
			mViewStack.push(name)
			switchView(index: idx)
			return true
		} else {
			CNLog(logLevel: .error, message: "No matched view")
			return false
		}
	}

	public func popViewController() -> Bool {
		if mViewStack.count > 1 {
			let _ = mViewStack.pop()
			if let name = mViewStack.peek() {
				CNLog(logLevel: .debug, message: "popViewController named: \"\(name)\"")
				if let idx = mIndexTable[name] {
					switchView(index: idx)
					return true
				}
			}
		}
		CNLog(logLevel: .error, message: "Can not happen")
		return false
	}

	public func replaceTopViewController(byName name: String) -> Bool {
		var oldname: String
		if let oname = mViewStack.pop() {
			oldname = oname
		} else {
			oldname = "<none>"
		}
		CNLog(logLevel: .error, message: "replaceViewController origin: \(oldname) -> named: \"\(name)\"")
		return pushViewController(byName: name)
	}
*/

}

