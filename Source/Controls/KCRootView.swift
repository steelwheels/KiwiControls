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
	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		self.wantsLayer = true
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
		#if os(OSX)
		self.wantsLayer = true
		#endif
	}

	deinit {
		/* Remove color observer */
		let vpref = CNPreference.shared.viewPreference
		vpref.removeObserver(observer: self, forKey: vpref.BackgroundColorItem)
		let spref = CNPreference.shared.systemPreference
		spref.removeObserver(observer: self, forKey: CNSystemPreference.InterfaceStyleItem)
	}

	public func setup(childView child: KCView){
		KCView.setAutolayoutMode(view: self)

		self.addSubview(child)
		super.allocateSubviewLayout(subView: child)
		setCoreView(view: child)

		let vpref = CNPreference.shared.viewPreference
		setBackgroundColor(color: vpref.backgroundColor)

		/* Add color observer */
		vpref.addObserver(observer: self, forKey: vpref.BackgroundColorItem)

		let spref = CNPreference.shared.systemPreference
		spref.addObserver(observer: self, forKey: CNSystemPreference.InterfaceStyleItem)
	}

	public func setBackgroundColor(color col: CNColor) {
		#if os(OSX)
		if let layer = self.layer {
			layer.backgroundColor = col.cgColor
		}
		#else
		self.backgroundColor = col
		#endif
	}

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			if let key = keyPath, let vals = change {
				if let _ = vals[.newKey] as? Dictionary<CNInterfaceStyle, CNColor> {
					switch key {
					case CNPreference.shared.viewPreference.BackgroundColorItem:
						let vpref = CNPreference.shared.viewPreference
						self.setBackgroundColor(color: vpref.backgroundColor)
					default:
						CNLog(logLevel: .error, message: "\(#file): Unknown key (1): \(key)")
					}
				} else if let _ = vals[.newKey] as? NSNumber {
				switch key {
				case CNSystemPreference.InterfaceStyleItem:
					let tpref = CNPreference.shared.viewPreference
					self.setBackgroundColor(color: tpref.backgroundColor)
				default:
					CNLog(logLevel: .error, message: "\(#file): Unknown key (2): \(key)")
				}
			}
			}
		})
	}

	public func updateContentSize() {
		let newsize = self.frame.size
		for subview in self.subviews {
			subview.frame.size  = newsize
			subview.bounds.size = newsize
		}
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(rootView: self)
	}
}

