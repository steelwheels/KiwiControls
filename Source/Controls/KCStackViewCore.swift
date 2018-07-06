/**
 * @file	KCStackViewCore.swift
 * @brief Define KCStackViewCore class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCStackViewCore : KCView
{
	#if os(OSX)
	@IBOutlet weak var mStackView: NSStackView!
	#else
	@IBOutlet weak var mStackView: UIStackView!
	#endif

	public func setup(frame frm: CGRect) {
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		self.bounds = bounds
		self.frame  = bounds
	}

	public var alignment: KCStackView.Alignment {
		get {
			let result: KCStackView.Alignment

			#if os(OSX)
				let orientation = self.mStackView.orientation
			#else
				let orientation = self.mStackView.axis
			#endif
			switch orientation {
			case .horizontal:
				switch self.mStackView.alignment {
				case .top:	result = .horizontal(align: .top)
				#if os(OSX)
				case .centerY:	result = .horizontal(align: .middle)
				#else
				case .center:	result = .horizontal(align: .middle)
				#endif
				case .bottom:	result = .horizontal(align: .bottom)
				default:
					NSLog("Unknown align: \(mStackView.alignment)")
					result = .horizontal(align: .middle)
				}
			case .vertical:
				switch self.mStackView.alignment {
				case .leading:	result = .vertical(align: .leading)
				#if os(OSX)
				case .centerX:	result = .vertical(align: .center)
				#else
				case .center:	result = .vertical(align: .center)
				#endif
				case .trailing:	result = .vertical(align: .trailing)
				default:
					NSLog("Unknown align: \(mStackView.alignment)")
					result = .vertical(align: .center)
				}
			}
			return result
		}
		set(newval){
			switch newval {
			case .horizontal(let align):
				#if os(OSX)
					self.mStackView.orientation = .horizontal
				#else
					self.mStackView.axis = .horizontal
				#endif
				switch align {
				case .top:	self.mStackView.alignment = .top
				#if os(OSX)
				case .middle:	self.mStackView.alignment = .centerY
				#else
				case .middle:	self.mStackView.alignment = .center
				#endif
				case .bottom:	self.mStackView.alignment = .bottom
				}
			case .vertical(let align):
				#if os(OSX)
					self.mStackView.orientation = .vertical
				#else
					self.mStackView.axis = .vertical
				#endif
				switch align {
				case .leading:	self.mStackView.alignment = .leading
				#if os(OSX)
				case .center:	self.mStackView.alignment = .centerX
				#else
				case .center:	self.mStackView.alignment = .center
				#endif
				case .trailing:	self.mStackView.alignment = .trailing
				}
			}
		}
	}

	public func addArrangedSubViews(subViews views:Array<KCView>){
		CNExecuteInMainThread(doSync: false, execute: { () -> Void in
			#if os(iOS)
				for view in views {
					self.mStackView.addArrangedSubview(view)
				}
			#else
				//self.mStackView.setViews(viewset, in: .top)
				for view in views {
					self.mStackView.addArrangedSubview(view)
				}
			#endif
		})
	}

	public func addArrangedSubView(subView view: KCView){
		CNExecuteInMainThread(doSync: false, execute: { () -> Void in
			#if os(iOS)
				self.mStackView.addArrangedSubview(view)
			#else
				self.mStackView.addArrangedSubview(view)
			#endif
		})
	}

	open func arrangedSubviews() -> Array<KCView> {
		return mStackView.arrangedSubviews as! Array<KCView>
	}

	open override var intrinsicContentSize: KCSize
	{
		var result = KCSize(width: 0.0, height: 0.0)
		let subviews = arrangedSubviews()
		for subview in subviews {
			let size = subview.intrinsicContentSize
			switch alignment {
			case .horizontal(_):
				result = KCUnionSize(sizeA: result, sizeB: size, doVertical: false)
			case .vertical(_):
				result = KCUnionSize(sizeA: result, sizeB: size, doVertical: true)
			}
		}
		return result
	}
}
