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
	#if os(iOS)
	private var mPickerView:	KCDocumentPickerViewController? = nil
	#endif

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	open override func viewDidLoad() {
		CNLog(type: .Debug, message: "viewDidLoad", file: #file, line: #line, function: #function)
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
			let pref = KCPreference.shared.documentTypePreference
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
				picker = KCDocumentPickerViewController(parentViewController: self)
				mPickerView = picker
			}
			picker.setLoaderFunction(loader: .view({
				(_ url: URL) -> String? in
				return loader(url)
			}))
			let pref = KCPreference.shared.documentTypePreference
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
		CNLog(type: .Flow, message: "pushViewController named: \"\(name)\"", file: #file, line: #line, function: #function)
		if let idx = mIndexTable[name] {
			mViewStack.push(name)
			switchView(index: idx)
			return true
		} else {
			CNLog(type: .Error, message: "No matched view", file: #file, line: #line, function: #function)
			return false
		}
	}

	public func popViewController() -> Bool {
		if mViewStack.count > 1 {
			let _ = mViewStack.pop()
			if let name = mViewStack.peek() {
				CNLog(type: .Flow, message: "popViewController named: \"\(name)\"", file: #file, line: #line, function: #function)
				if let idx = mIndexTable[name] {
					switchView(index: idx)
					return true
				}
			}
		}
		CNLog(type: .Error, message: "Can not happen", file: #file, line: #line, function: #function)
		return false
	}

	public func replaceTopViewController(byName name: String) -> Bool {
		var oldname: String
		if let oname = mViewStack.pop() {
			oldname = oname
		} else {
			oldname = "<none>"
		}
		CNLog(type: .Flow, message: "replaceViewController origin: \(oldname) -> named: \"\(name)\"", file: #file, line: #line, function: #function)
		return pushViewController(byName: name)
	}

	private func switchView(index idx: Int){
		#if os(OSX)
			self.selectedTabViewItemIndex = idx
		#else
			self.selectedIndex = idx
		#endif
	}

	public func dump(to console: CNConsole){
		console.print(string: "multi-view: {\n")

		let stackdesc = "[" + mViewStack.peekAll().joined(separator: ",") + "]"
		console.print(string: " stack: " + stackdesc + "\n")

		var indices: Array<String> = []
		for (key, value) in mIndexTable {
			indices.append("\(key):\(value)")
		}
		console.print(string: " index: " + indices.joined(separator: ",") + "\n")

		console.print(string: "}\n")
	}
}

