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

		/* Layout for self */
		setResizePriority(doGrowHorizontally: false, doGrowVertically: false)

		/* Layout for subview */
		self.addSubview(child)
		setCoreView(view: child)
		allocateSubviewLayout(subView: child)
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
					NSLog("Finished\n")
				})
				let urls = picker.result
				NSLog("Result : \(urls)")
			}
		#endif
		return nil
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(rootView: self)
	}
}

