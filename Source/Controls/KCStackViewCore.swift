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
	
	public var orientation: CNOrientation {
		get {
			#if os(OSX)
				switch mStackView.orientation {
				case .horizontal: return .Horizontal
				case .vertical:   return .Vertical
				}
			#else
				switch mStackView.axis {
				case .horizontal: return .Horizontal
				case .vertical:   return .Vertical
				}
			#endif
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(OSX)
					switch newval {
					case .Vertical:   self.mStackView.orientation = .vertical
					case .Horizontal: self.mStackView.orientation = .horizontal
					}
				#else
					switch newval {
					case .Vertical:   self.mStackView.axis = .vertical
					case .Horizontal: self.mStackView.axis = .horizontal
					}
				#endif
			})
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
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(OSX)
					switch newval {
					case .Leading:
						self.mStackView.alignment = .leading
					case .Center:
						if self.orientation == .Vertical {
							self.mStackView.alignment = .centerY
						} else {
							self.mStackView.alignment = .centerX
						}
					case .Trailing:
						self.mStackView.alignment = .trailing
					}
				#else
					switch newval {
					case .Leading:
						self.mStackView.alignment = .leading
					case .Center:
						self.mStackView.alignment = .center
					case .Trailing:
						self.mStackView.alignment = .trailing
					}
				#endif
			})
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
			if size.width > 0.0 && size.height > 0.0 {
				switch orientation {
				case .Horizontal:
					result = KCView.unionHolizontalIntrinsicSizes(left: result, right: size)
				case .Vertical:
					result = KCView.unionVerticalIntrinsicSizes(top: result, bottom: size)
				}
			} else {
				return KCSize(width: -1.0, height: -1.0)
			}
		}
		return result
	}
	
	open override func printDebugInfo(indent idt: Int){
		super.printDebugInfo(indent: idt)
		if let v = mStackView {
			KCPrintDebugInfo(view: v, indent: idt+1)

			let algstr = alignment.description
			KCPrintIndent(indent: idt+1) ; Swift.print("- alignment:   \(algstr)")
			let orstr = orientation.description
			KCPrintIndent(indent: idt+1) ; Swift.print("- orientation: \(orstr)")
		}
		var viewid = 0
		for v in mStackView.arrangedSubviews {
			KCPrintIndent(indent: idt+2) ; Swift.print("[\(viewid)] ")
			KCPrintDebugInfo(view: v, indent: idt+2)
			viewid = viewid + 1
		}
	}
}
