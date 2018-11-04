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
			#if os(OSX)
				let axis      = self.mStackView.orientation
			#else
				let axis      = self.mStackView.axis
			#endif

			let result: CNAlignment
			switch axis {
			case .horizontal:
				switch alignment {
				case .leading:	result = .Left
				#if os(OSX)
					case .centerX, .centerY: result = .Center
				#else
					case .center:		 result = .Center
				#endif
				case .trailing:	result = .Right
				default:	result = .Left
				}
			case .vertical:
				switch alignment {
				case .leading:	result = .Top
				#if os(OSX)
					case .centerX, .centerY: result = .Middle
				#else
					case .center:		 result = .Middle
				#endif
				case .trailing:	result = .Bottom
				default:	result = .Top
				}
			}
			return result

		}
		set(newval){
			#if os(OSX)
				let orientation: NSUserInterfaceLayoutOrientation
			#else
				let orientation: NSLayoutConstraint.Axis
			#endif
			#if os(OSX)
				let alignment:   NSLayoutConstraint.Attribute
			#else
				let alignment: UIStackView.Alignment
			#endif
			switch newval {
			case .Left:
				orientation = .vertical
				alignment   = .leading
			case .Center:
				orientation = .vertical
				#if os(OSX)
					alignment   = .centerX
				#else
					alignment   = .center
				#endif
			case .Right:
				orientation = .vertical
				alignment   = .trailing
			case .Top:
				orientation = .horizontal
				alignment   = .top
			case .Middle:
				orientation = .horizontal
				#if os(OSX)
					alignment   = .centerY
				#else
					alignment   = .center
				#endif
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
