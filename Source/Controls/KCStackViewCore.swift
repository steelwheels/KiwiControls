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
	public enum Axis {
		case vertical
		case horizontal

		public var description: String {
			get {
				let result: String
				switch self {
				case .vertical:	  result = "vertical"
				case .horizontal: result = "horizontal"
				}
				return result
			}
		}
	}

	public enum Alignment {
		case left
		case right
		case top
		case bottom
		case center
		case fill

		public var description: String {
			get {
				let result: String
				switch self {
				case .left:		result = "left"
				case .right:		result = "right"
				case .top:		result = "top"
				case .bottom:		result = "bottom"
				case .center:		result = "center"
				case .fill:		result = "fill"
				}
				return result
			}
		}
	}

	public enum Distribution {
		case fill
		case fillEqually
		case equalSpacing

		public var description: String {
			get {
				let result: String
				switch self {
				case .fill:		result = "fill"
				case .fillEqually:	result = "fillEqually"
				case .equalSpacing:	result = "equalSpacing"
				}
				return result
			}
		}
	}

	#if os(OSX)
	@IBOutlet weak var mStackView: NSStackView!
	#else
	@IBOutlet weak var mStackView: UIStackView!
	#endif


	/* macOS does not support "fill" alignment mode.
	 * This flag presents the "fill" mode supported by this class is
	 * active or not.
 	 */
	#if os(OSX)
		private var mIsFillAlignmentMode = false
	#endif

	public func setup(frame frm: CGRect) {
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		self.bounds = bounds
		self.frame  = bounds
	}

	public var axis: Axis {
		get {
			#if os(OSX)
				let result: Axis
				switch mStackView.orientation {
				case .vertical:   result = Axis.vertical
				case .horizontal: result = Axis.horizontal
				}
				return result
			#else
				let result: Axis
				switch mStackView.axis {
				case .vertical:	  result = Axis.vertical
				case .horizontal: result = Axis.horizontal
				}
				return result
			#endif
		}
		set(newval){
			#if os(OSX)
				switch newval {
				case .vertical:	  mStackView.orientation = NSUserInterfaceLayoutOrientation.vertical
				case .horizontal: mStackView.orientation = NSUserInterfaceLayoutOrientation.horizontal
				}
			#else
				switch newval {
				case .vertical:   mStackView.axis = NSLayoutConstraint.Axis.vertical
				case .horizontal: mStackView.axis = NSLayoutConstraint.Axis.horizontal
				}
			#endif
		}
	}

	public var alignment: Alignment {
		get {
			let result: Alignment
			let isvert = axis == .vertical
			switch mStackView.alignment {
			#if os(OSX)
				case .left:	result = mIsFillAlignmentMode ? .fill : .left
				case .right:	result = .right
				case .top:	result = .top
				case .bottom:	result = .bottom
				case .centerX:	result = .center
				case .centerY:	result = .center
			#else
				case .leading:	result = isvert ? .left  : .top
				case .trailing:	result = isvert ? .right : .bottom
				case .center:	result = .center
				case .fill:	result = .fill
			#endif
			default:
				NSLog("Unsupported alignment at \(#function)")
				result = .left
			}
			return result
		}
		set(newval){
			let isvert = axis == .vertical
			var dofill = false
			switch newval {
			#if os(OSX)
				case .left:	mStackView.alignment = .left
				case .right:	mStackView.alignment = .right
				case .top:	mStackView.alignment = .top
				case .bottom:	mStackView.alignment = .bottom
				case .center:	mStackView.alignment = isvert ? .centerY : .centerX
				case .fill:	mStackView.alignment = isvert ? .left : .top
						dofill = true
			#else
				case .left:	mStackView.alignment = .leading
				case .right:	mStackView.alignment = .trailing
				case .top:	mStackView.alignment = .leading
				case .bottom:	mStackView.alignment = .trailing
				case .center:	mStackView.alignment = .center
				case .fill: 	mStackView.alignment = .fill
			#endif
			}
			#if os(OSX)
				if dofill != mIsFillAlignmentMode {
					activateConstraints(doActivate: dofill)
					mIsFillAlignmentMode = dofill
				}
			#endif
		}
	}

	public var distributtion: Distribution {
		get {
			let result: Distribution
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

	open override func sizeToFit() {
		let dovert     = (axis == .vertical)
		var entiresize = KCSize.zero
		for subview in mStackView.arrangedSubviews {
			entiresize = KCUnionSize(sizeA: entiresize, sizeB: subview.frame.size, doVertical: dovert)
		}
		super.resize(entiresize)
	}

	public func addArrangedSubViews(subViews views:Array<KCView>){
		CNExecuteInMainThread(doSync: false, execute: { () -> Void in
			for view in views {
				self.addArrangedSubViewInMainThread(subView: view)
			}
		})
	}

	public func addArrangedSubView(subView view: KCView){
		CNExecuteInMainThread(doSync: false, execute: { () -> Void in
			self.addArrangedSubViewInMainThread(subView: view)
		})
	}

	private func addArrangedSubViewInMainThread(subView view: KCView){
		/* Add subview */
		self.mStackView.addArrangedSubview(view)
		/* Set constraints */
		#if os(OSX)
			switch axis {
			case .horizontal:
				setConstraint(toView: view, attribute: .top)
				setConstraint(toView: view, attribute: .bottom)
			case .vertical:
				setConstraint(toView: view, attribute: .left)
				setConstraint(toView: view, attribute: .right)
			}
		#endif
	}

	#if os(OSX)
	private func setConstraint(toView toview: KCView, attribute attr: NSLayoutConstraint.Attribute){
		let constr = NSLayoutConstraint(item: mStackView, attribute: attr, relatedBy: .equal, toItem: toview, attribute: attr, multiplier: 1.0, constant: 0.0)
		constr.isActive = mIsFillAlignmentMode
		mStackView.addConstraint(constr)
	}
	#endif

	#if os(OSX)
	private func activateConstraints(doActivate active: Bool) {
		for constr in mStackView.constraints {
			constr.isActive = active
		}
	}
	#endif

	open func arrangedSubviews() -> Array<KCView> {
		return mStackView.arrangedSubviews as! Array<KCView>
	}

	open override var intrinsicContentSize: KCSize {
		get {
			let dovert = axis == .vertical
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
