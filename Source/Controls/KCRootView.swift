/**
 * @file	KCRootView.swift
 * @brief	Define KCRootView class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

open class KCRootView: KCCoreView
{
	private weak var mViewController: KCViewController? = nil

	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame) ;
	}
	#endif

	public convenience init(){
		#if os(OSX)
		let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 272)
		#else
		let frame = CGRect(x: 0.0, y: 0.0, width: 256, height: 256)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
	}

	public func setup(viewController vcont: KCViewController, childView child: KCView){
		/* Keep view controller reference */
		mViewController = vcont

		self.addSubview(child)
		setCoreView(view: child)

		#if os(iOS)
			self.backgroundColor = KCPreference.shared.layoutPreference.backgroundColor
		#endif
	}

	public var viewController: KCViewController? {
		get { return mViewController }
	}

	public override var fixedSize: KCSize? {
		get {
			return super.fixedSize
		}
		set(newval){
			if let core: KCCoreView = super.getCoreView() {
				core.fixedSize = newval
			}
			super.fixedSize = newval
		}
	}

	public func selectInputFile(title ttext: String, documentTypes allowedUTIs: [String]) -> URL?
	{
		#if os(OSX)
			/* get preference and collect extensions for given UTIs */
			let pref = KCPreference.shared.documentTypePreference
			let exts = pref.fileExtensions(forUTIs: allowedUTIs)
			if exts.count > 0 {
				if let url = URL.openPanel(title: ttext, selection: .SelectFile, fileTypes: exts) {
					return url
				}
			}
		#else
			if let vcont = mViewController {
				// Do any additional setup after loading the view, typically from a nib.
				let picker = KCDocumentPickerViewController(documentTypes: allowedUTIs, in: .import)
				vcont.present(picker, animated: true, completion: {
					() -> Void in
				})
				return picker.waitResult()
			}
		#endif
		return nil
	}

	public func selectInputFile(title ttext: String, fileExtensions exts: [String]) -> URL?
	{
		#if os(OSX)
		if exts.count > 0 {
			if let url = URL.openPanel(title: ttext, selection: .SelectFile, fileTypes: exts) {
				return url
			}
		}
		#else
		if let vcont = mViewController {
			let pref = KCPreference.shared.documentTypePreference
			let utis = pref.UTIs(forExtensions: exts)
			let picker = KCDocumentPickerViewController(documentTypes: utis, in: .import)
			vcont.present(picker, animated: true, completion: {
				() -> Void in
			})
			return picker.waitResult()
		}
		#endif
		return nil
	}

	public func selectInputDirectory(title ttext: String) -> URL?
	{
		#if os(OSX)
		if let url = URL.openPanel(title: ttext, selection: .SelectDirectory, fileTypes: []) {
			return url
		}
		#endif
		return nil
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(rootView: self)
	}
}

