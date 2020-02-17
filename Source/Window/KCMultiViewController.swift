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

open class KCMultiViewController : KCMultiViewControllerBase, KCWindowDelegate, CNLogging
{
	private var mIndexTable:	Dictionary<String, Int> = [:]	/* name -> index */
	private var mViewStack:		CNStack = CNStack<String>()	/* name */
	private var mConsole:		CNConsole? = nil
	#if os(OSX)
	private var mContentSize:	KCSize = KCSize.zero
	#else
	private var mPickerView:	KCDocumentPickerViewController? = nil
	#endif

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
		log(type: .flow, string: "viewDidLoad", file: #file, line: #line, function: #function)
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
		#if os(OSX)
			mContentSize = self.view.frame.size
		#endif
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
				picker = KCDocumentPickerViewController(parentViewController: self, console: mConsole)
				mPickerView = picker
			}
			picker.setLoaderFunction(loader: .url({
				(_ url: URL) -> Void in
				loader(url)
			}))
			let pref = CNPreference.shared.documentTypePreference
			let utis = pref.UTIs(forExtensions: exts)
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
				picker = KCDocumentPickerViewController(parentViewController: self, console: mConsole)
				mPickerView = picker
			}
			picker.setLoaderFunction(loader: .view({
				(_ url: URL) -> String? in
				return loader(url)
			}))
			let pref = CNPreference.shared.documentTypePreference
			let utis = pref.UTIs(forExtensions: exts)
			picker.openPicker(UTIs: utis)
		#endif
	}

	public func hasViewController(name nm: String) -> Bool {
		if let _ = mIndexTable[nm] {
			return true
		} else {
			return false
		}
	}

	public func subViewControllers() -> Array<KCSingleViewController> {
		var result: Array<KCSingleViewController> = []
		#if os(OSX)
			for item in tabViewItems {
				if let vcont = item.viewController as? KCSingleViewController {
					result.append(vcont)
				} else {
					log(type: .error, string: "Unknown object", file: #file, line: #line, function: #function)
				}
			}
		#else
			if let vconts = viewControllers {
				for vcont in vconts {
					if let svcont = vcont as? KCSingleViewController {
						result.append(svcont)
					} else {
						log(type: .error, string: "Unknown object", file: #file, line: #line, function: #function)
					}
				}
			}
		#endif
		return result
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
		log(type: .flow, string: "pushViewController named: \"\(name)\"", file: #file, line: #line, function: #function)
		if let idx = mIndexTable[name] {
			mViewStack.push(name)
			switchView(index: idx)
			return true
		} else {
			log(type: .error, string: "No matched view", file: #file, line: #line, function: #function)
			return false
		}
	}

	public func popViewController() -> Bool {
		if mViewStack.count > 1 {
			let _ = mViewStack.pop()
			if let name = mViewStack.peek() {
				log(type: .flow, string:  "popViewController named: \"\(name)\"", file: #file, line: #line, function: #function)
				if let idx = mIndexTable[name] {
					switchView(index: idx)
					return true
				}
			}
		}
		log(type: .error, string: "Can not happen", file: #file, line: #line, function: #function)
		return false
	}

	public func replaceTopViewController(byName name: String) -> Bool {
		var oldname: String
		if let oname = mViewStack.pop() {
			oldname = oname
		} else {
			oldname = "<none>"
		}
		log(type: .error, string: "replaceViewController origin: \(oldname) -> named: \"\(name)\"", file: #file, line: #line, function: #function)
		return pushViewController(byName: name)
	}

	private func switchView(index idx: Int){
		#if os(OSX)
			self.selectedTabViewItemIndex = idx
		#else
			self.selectedIndex = idx
		#endif
	}

	public func windowDidResize(_ notification: Notification) {
		if let viewctrl = currentViewController() as? KCSingleViewController {
			viewctrl.windowDidResize(parentViewController: self)
		} else {
			NSLog("[Error] No view controller")
		}
	}

	private func currentViewController() -> KCViewController? {
		#if os(OSX)
			let item = self.tabViewItems[self.selectedTabViewItemIndex]
			return item.viewController
		#else
			return super.selectedViewController
		#endif
	}

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
}

