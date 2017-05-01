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

open class KCStackViewCore : KCView
{
	#if os(OSX)
	@IBOutlet weak var mStackView: NSStackView!
	#else
	@IBOutlet weak var mStackView: UIStackView!
	#endif
	
	public var axis: KCStackView.Axis {
		get {
			#if os(OSX)
				switch mStackView.orientation {
				case .horizontal: return .Holizontal
				case .vertical:   return .Vertical
				}
			#else
				switch mStackView.axis {
				case .horizontal: return .Holizontal
				case .vertical:   return .Vertical
				}
			#endif
		}
		set(newval){
			#if os(OSX)
				switch newval {
				case .Vertical:   mStackView.orientation = .vertical
				case .Holizontal: mStackView.orientation = .horizontal
				}
			#else
				switch newval {
				case .Vertical:   mStackView.axis = .vertical
				case .Holizontal: mStackView.axis = .horizontal
				}
			#endif
		}
	}

	public var alignment: KCStackView.Alignment {
		get {
			#if os(OSX)
				switch mStackView.alignment {
				case .leading:			return .Leading
				case .centerX, .centerY:	return .Center
				case .trailing:			return .Trailing
				default:			fatalError("Unknown alignment")
				}
			#else
				switch mStackView.alignment {
				case .leading:			return .Leading
				case .center:			return .Center
				case .trailing:			return .Trailing
				default:			fatalError("Unknown alignment")
				}
			#endif
		}
		set(newval){
			#if os(OSX)
				switch newval {
				case .Leading:
					mStackView.alignment = .leading
				case .Center:
					if axis == .Vertical {
						mStackView.alignment = .centerY
					} else {
						mStackView.alignment = .centerX
					}
				case .Trailing:
					mStackView.alignment = .trailing
				}
			#else
				switch newval {
				case .Leading:
					mStackView.alignment = .leading
				case .Center:
					mStackView.alignment = .center
				case .Trailing:
					mStackView.alignment = .trailing
				}
			#endif
		}
	}

	public func setViews(views vs:Array<KCView>){
		#if os(iOS)
			for view in vs {
				mStackView.addArrangedSubview(view)
			}
		#else
			mStackView.setViews(vs, in: .top)
		#endif
	}

	open override func printDebugInfo(indent idt: Int){
		super.printDebugInfo(indent: idt)
		if let v = mStackView {
			v.printDebugInfo(indent: idt+1)
		}
		var viewid = 0
		for v in mStackView.arrangedSubviews {
			printIndent(indent: idt+2)
			Swift.print("[\(viewid)] ")
			v.printDebugInfo(indent: idt+2)
			viewid = viewid + 1
		}
	}
}
