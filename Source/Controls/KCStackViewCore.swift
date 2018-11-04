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

	open override func sizeToFit() {
		let dovert     = alignment.isVertical
		var entiresize = KCSize.zero
		for subview in mStackView.arrangedSubviews {
			entiresize = KCUnionSize(sizeA: entiresize, sizeB: subview.frame.size, doVertical: dovert)
		}
		super.resize(entiresize)
	}

	public var alignment: CNAlignment {
		get {
			let alignment = self.mStackView.alignment

			let result: CNAlignment
			switch alignment {
			case .leading:		result = .Left
			case .centerX:		result = .Center
			case .trailing:		result = .Right
			case .top:		result = .Top
			case .centerY:		result = .Middle
			case .bottom:		result = .Bottom
			default:		result = .Left
			}
			return result

		}
		set(newval){
			let orientation: NSUserInterfaceLayoutOrientation
			let alignment:   NSLayoutConstraint.Attribute
			switch newval {
			case .Left:
				orientation = .vertical
				alignment   = .leading
			case .Center:
				orientation = .vertical
				alignment   = .centerX
			case .Right:
				orientation = .vertical
				alignment   = .trailing
			case .Top:
				orientation = .horizontal
				alignment   = .top
			case .Middle:
				orientation = .horizontal
				alignment   = .centerY
			case .Bottom:
				orientation = .horizontal
				alignment   = .bottom
			}
			#if os(OSX)
				self.mStackView.orientation = orientation
				self.mStackView.alignment   = alignment
			#else
				self.mStackView.axis        = orientation
				self.mStackView.alignment   = alignment
			#endif
		}
	}

	public var distributtion: KCStackView.Distribution {
		get {
			let result: KCStackView.Distribution
			switch mStackView.distribution {
			case .fill:		result = .fill
			case .fillEqually:	result = .fillEqually
			case .equalSpacing:	result = .equalSpacing
			default:		result = .fill
			}
			return result
		}
		set(newval){
			#if os(OSX)
				let newdist: NSStackView.Distribution
			#else
				let newdist: UIStackView.Distribution
			#endif
			switch newval {
			case .fill: 		newdist = .fill
			case .fillEqually:	newdist = .fillEqually
			case .equalSpacing:	newdist = .equalSpacing
			}
			mStackView.distribution = newdist
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

	open override var intrinsicContentSize: KCSize {
		get {
			let dovert = alignment.isVertical
			var result = KCSize(width: 0.0, height: 0.0)
			let subviews = arrangedSubviews()
			for subview in subviews {
				let size = subview.intrinsicContentSize
				result = KCUnionSize(sizeA: result, sizeB: size, doVertical: dovert)
			}
			return result
		}
	}
}
