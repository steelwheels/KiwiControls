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

		#if os(OSX)
			mStackView.orientation  = .vertical
			mStackView.alignment    = .centerX
			mStackView.distribution = .fill
		#else
			mStackView.axis		= .vertical
			mStackView.alignment	= .center
			mStackView.distribution = .fill
		#endif
	}

	public var axis: CNAxis {
		get 		{ return getAxis()					}
		set(newval)	{ set(axis: newval, alignment: getAlignment())		}
	}

	public var alignment: CNAlignment {
		get		{ return getAlignment() 				}
		set(newval)	{ set(axis: getAxis(), alignment: newval)		}
	}

	private func getAxis() -> CNAxis {
		#if os(OSX)
			let result: CNAxis
			switch mStackView.orientation {
			case .vertical:   result = CNAxis.vertical
			case .horizontal: result = CNAxis.horizontal
			@unknown default: result = CNAxis.vertical
		}
			return result
		#else
			let result: CNAxis
			switch mStackView.axis {
			case .vertical:	  result = CNAxis.vertical
			case .horizontal: result = CNAxis.horizontal
			@unknown default: result = CNAxis.vertical
			}
			return result
		#endif
	}

	private func getAlignment() -> CNAlignment {
		#if os(OSX)
			if mIsFillAlignmentMode {
				return .fill
			}
			let result: CNAlignment
			switch mStackView.alignment {
			case .left, .top:		result = .leading
			case .right, .bottom:		result = .trailing
			case .centerX, .centerY:	result = .center
			default:
				CNLog(type: .Error, message: "Unsupported alignment", file: #file, line: #line, function: #function)
				result = .leading
			}
			return result
		#else
			let result: CNAlignment
			switch mStackView.alignment {
			case .leading:			result = .leading
			case .trailing:			result = .trailing
			case .center:			result = .center
			case .fill:			result = .fill
			default:
				CNLog(type: .Error, message: "Unsupported alignment", file: #file, line: #line, function: #function)
				result = .leading
			}
			return result
		#endif
	}

	private func set(axis axs: CNAxis, alignment align: CNAlignment) {
		/* Set axis */
		#if os(OSX)
			switch axs {
			case .vertical:	  mStackView.orientation = NSUserInterfaceLayoutOrientation.vertical
			case .horizontal: mStackView.orientation = NSUserInterfaceLayoutOrientation.horizontal
			}
		#else
			switch axs {
			case .vertical:   mStackView.axis = NSLayoutConstraint.Axis.vertical
			case .horizontal: mStackView.axis = NSLayoutConstraint.Axis.horizontal
			}
		#endif
		/* Set alignment */
		#if os(OSX)
			switch align {
			case .leading, .fill:
				switch axs {
				case .horizontal:	mStackView.alignment = .top
				case .vertical:		mStackView.alignment = .left
				}
				mIsFillAlignmentMode = (align == .fill)
			case .trailing:
				switch axs {
				case .horizontal:	mStackView.alignment = .bottom
				case .vertical:		mStackView.alignment = .right
				}
			case .center:
				switch axs {
				case .horizontal:	mStackView.alignment = .centerY
				case .vertical:		mStackView.alignment = .centerX
				}
			}
		#else
			switch align {
			case .leading:
				mStackView.alignment = .leading
			case .trailing:
				mStackView.alignment = .trailing
			case .fill:
				mStackView.alignment = .fill
			case .center:
				mStackView.alignment = .center
			}
		#endif
	}

	public var distributtion: CNDistribution {
		get {
			let result: CNDistribution
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
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				for view in views {
					myself.addArrangedSubViewInMainThread(subView: view)
				}
			}
		})
	}

	public func addArrangedSubView(subView view: KCView){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				myself.addArrangedSubViewInMainThread(subView: view)
			}
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
		let constr = NSLayoutConstraint(item: mStackView!, attribute: attr, relatedBy: .equal, toItem: toview, attribute: attr, multiplier: 1.0, constant: 0.0)
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
