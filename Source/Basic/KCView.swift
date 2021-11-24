/**
 * @file	KCView.swift
 * @brief	Define KCView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

#if os(iOS)
	public typealias KCViewBase 		= UIView
#else
	public typealias KCViewBase 		= NSView
#endif

public enum KCMouseEvent {
	case down
	case drag
	case up

	public var description: String {
		get {
			var result:String = "?"
			switch self {
			case .up:	result = "up"
			case .drag:	result = "drag"
			case .down:	result = "down"
			}
			return result
		}
	}
}

private func convertCoodinate(sourcePoint p: CGPoint, bounds b: CGRect) -> CGPoint
{
	let y = (b.size.height - p.y)
	return CGPoint(x: p.x, y: y)
}

extension KCViewBase
{
	public func rootView() -> KCRootView? {
		var curview: KCViewBase = self
		while true {
			if let sview = curview.superview {
				if let root = sview as? KCRootView {
					return root
				} else {
					curview = sview
				}
			} else {
				break
			}
		}
		return nil
	}

	/* for autolayout */
	public enum ExpansionPriority: Int {
		case high
		case middle
		case low
		case fixed

		public static func sortedPriorities() -> Array<ExpansionPriority> {
			return [.fixed, .low, .middle, .high]
		}

		static public func fromValue(_ pri: KCLayoutPriority) -> ExpansionPriority {
			let result: ExpansionPriority
			if pri >= ExpansionPriority.fixed.toValue() {
				result = .fixed
			} else if pri >= ExpansionPriority.low.toValue() {
				result = .low
			} else if pri >= ExpansionPriority.middle.toValue() {
				result = .middle
			} else {
				result = .high
			}
			return result
		}

		public func toValue() -> KCLayoutPriority {
			#if os(OSX)
				switch self {
				case .high:	return .windowSizeStayPut - 1
				case .middle:	return .windowSizeStayPut + 1		// = 500 + 1
				case .low:	return .defaultHigh			// = 750
				case .fixed:	return .required			// = 1000
				}
			#else
				switch self {
				case .high:	return .defaultLow - 1
				case .middle:	return .defaultLow
				case .low:	return .defaultHigh
				case .fixed:	return .required - 1
				}
			#endif
		}

		public static func union(_ s0: ExpansionPriority, _ s1: ExpansionPriority) -> ExpansionPriority {
			let v0 = s0.toValue()
			let v1 = s1.toValue()
			return fromValue(min(v0, v1))
		}

		public func description() -> String {
			let result: String
			switch self {
			case .high:	result = "high"
			case .middle:	result = "middle"
			case .low:	result = "low"
			case .fixed:	result = "fixed"
			}
			return result
		}
	}

	public struct ExpansionPriorities {
		public var holizontalHugging:		ExpansionPriority
		public var holizontalCompression:	ExpansionPriority
		public var verticalHugging:		ExpansionPriority
		public var verticalCompression:		ExpansionPriority

		public init(holizontalHugging 		hh: ExpansionPriority,
			    holizontalCompression	hc: ExpansionPriority,
			    verticalHugging		vh: ExpansionPriority,
			    verticalCompression		vc: ExpansionPriority){
			holizontalHugging	= hh
			holizontalCompression	= hc
			verticalHugging		= vh
			verticalCompression	= vc
		}

		public static func union(_ s0: ExpansionPriorities, _ s1: ExpansionPriorities) -> ExpansionPriorities {
			let hh = ExpansionPriority.union(s0.holizontalHugging, s1.holizontalHugging)
			let hc = ExpansionPriority.union(s0.holizontalCompression, s1.holizontalCompression)
			let vh = ExpansionPriority.union(s0.verticalHugging, s1.verticalHugging)
			let vc = ExpansionPriority.union(s0.verticalCompression, s1.verticalCompression)
			return ExpansionPriorities(holizontalHugging: hh, holizontalCompression: hc, verticalHugging: vh, verticalCompression: vc)
		}

	}

	#if os(iOS)
	public func setFrameSize(size sz: CGSize) {
		self.frame.size  = sz
		self.bounds.size = sz
	}
	#endif

	public func setExpansionPriorities(priorities prival: ExpansionPriorities) {
		setContentHuggingPriority(prival.holizontalHugging.toValue(), for: .horizontal)
		setContentCompressionResistancePriority(prival.holizontalCompression.toValue(), for: .horizontal)

		setContentHuggingPriority(prival.verticalHugging.toValue(), for: .vertical)
		setContentCompressionResistancePriority(prival.verticalCompression.toValue(), for: .vertical)
	}

	public func expansionPriority() -> ExpansionPriorities {
		let hhval = contentHuggingPriority(for: .horizontal)
		let hhpri = ExpansionPriority.fromValue(hhval)

		let hcval = contentCompressionResistancePriority(for: .horizontal)
		let hcpri = ExpansionPriority.fromValue(hcval)

		let vhval = contentHuggingPriority(for: .vertical)
		let vhpri = ExpansionPriority.fromValue(vhval)

		let vcval = contentCompressionResistancePriority(for: .vertical)
		let vcpri = ExpansionPriority.fromValue(vcval)

		return ExpansionPriorities(holizontalHugging: hhpri,
					   holizontalCompression: hcpri,
					   verticalHugging: vhpri,
					   verticalCompression: vcpri)
	}
}

open class KCView : KCViewBase
{
	public static var noIntrinsicValue: CGFloat {
		get {
			#if os(OSX)
				return noIntrinsicMetric
			#else
				return UIView.noIntrinsicMetric
			#endif
		}
	}

	public class func setAutolayoutMode(view v: KCViewBase) {
		v.translatesAutoresizingMaskIntoConstraints = false
		v.autoresizesSubviews = true
	}

	public class func setAutolayoutMode(views vs: Array<KCViewBase>) {
		for v in vs {
			setAutolayoutMode(view: v)
		}
	}

	/*
	 * Event control
	 */
	#if os(iOS)
	final public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let pos = eventLocation(touches: touches)
		acceptMouseEvent(mouseEvent: .down,mousePosition: pos)
	}
	#else
	final public override func mouseDown(with event: NSEvent) {
		let pos = eventLocation(event: event)
		acceptMouseEvent(mouseEvent: .down,mousePosition: pos)
	}
	#endif

	#if os(iOS)
	final public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let pos = eventLocation(touches: touches)
		acceptMouseEvent(mouseEvent: .drag,mousePosition: pos)
	}
	#else
	final public override func mouseDragged(with event: NSEvent) {
		let pos = eventLocation(event: event)
		acceptMouseEvent(mouseEvent: .drag,mousePosition: pos)
	}
	#endif

	#if os(iOS)
	final public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let pos = eventLocation(touches: touches)
		acceptMouseEvent(mouseEvent: .up,mousePosition: pos)
	}
	#else
	final public override func mouseUp(with event: NSEvent) {
		let pos = eventLocation(event: event)
		acceptMouseEvent(mouseEvent: .up,mousePosition: pos)
	}
	#endif

	#if os(iOS)
	open func eventLocation(touches tchs: Set<UITouch>) -> CGPoint {
		if let touch = tchs.first {
			let pos = touch.location(in: self)
			//Swift.print(" -> event:\(pos.description)")
			return convertCoodinate(sourcePoint: pos, bounds: bounds)
		} else {
			fatalError("No touch location")
		}
	}
	#else
	private func eventLocation(event evt: NSEvent) -> CGPoint {
		return self.convert(evt.locationInWindow, from: nil)
	}
	#endif

	open func acceptMouseEvent(mouseEvent event:KCMouseEvent, mousePosition position:CGPoint){
		/* Must be override by sub class */
	}

	/*
	 * Update area control
	 */
	private var areaToBeDisplay = CGRect.zero

	open override func draw(_ dirtyRect: CGRect){
		super.draw(dirtyRect)
		areaToBeDisplay = CGRect.zero
	}

	/*
	 * layout
	 */
	open func requireLayout() {
		CNLog(logLevel: .detail, message: "require view layout")
		#if os(OSX)
			self.needsLayout = true
		#else
			self.setNeedsLayout()
		#endif
	}

	open func requireDisplay() {
		CNLog(logLevel: .detail, message: "require view display")
		#if os(OSX)
			self.needsDisplay = true
		#else
			self.setNeedsDisplay()
		#endif
	}

	#if os(iOS)
	open func setFrameSize(_ newsize: CGSize) {
		self.frame.size = newsize
	}
	#endif

	open override var intrinsicContentSize: CGSize {
		get {
			return CGSize(width: KCView.noIntrinsicValue, height: KCView.noIntrinsicValue)
		}
	}

	open func setExpandabilities(priorities prival: ExpansionPriorities) {
		setExpansionPriorities(priorities: prival)
	}

	public func allocateSubviewLayout(subView sview: KCViewBase){
		sview.translatesAutoresizingMaskIntoConstraints = false
		addConstraint(KCView.allocateLayout(fromView: sview,  toView: self,   attribute: .top,    length: 0.0)) ;
		addConstraint(KCView.allocateLayout(fromView: sview,  toView: self,   attribute: .left,   length: 0.0)) ;
		addConstraint(KCView.allocateLayout(fromView: self,   toView: sview,  attribute: .bottom, length: 0.0)) ;
		addConstraint(KCView.allocateLayout(fromView: self,   toView: sview,  attribute: .right,  length: 0.0)) ;
	}

	public func allocateSubviewLayout(subView sview: KCViewBase, in inset: KCEdgeInsets){
		sview.translatesAutoresizingMaskIntoConstraints = false
		addConstraint(KCView.allocateLayout(fromView: sview,  toView: self,   attribute: .top,    length: inset.top)) ;
		addConstraint(KCView.allocateLayout(fromView: sview,  toView: self,   attribute: .left,   length: inset.left)) ;
		addConstraint(KCView.allocateLayout(fromView: self,   toView: sview,  attribute: .bottom, length: inset.bottom)) ;
		addConstraint(KCView.allocateLayout(fromView: self,   toView: sview,  attribute: .right,  length: inset.right)) ;
	}

	private class func allocateLayout(fromView fview : KCViewBase, toView tview: KCViewBase, attribute attr: KCLayoutAttribute, length len: CGFloat) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: fview, attribute: attr, relatedBy: KCLayoutRelation.equal, toItem: tview, attribute: attr, multiplier: 1.0, constant: len) ;
	}

	public class func setFixedOriginConstaint(fromView fview : KCViewBase, toView tview: KCViewBase, origin orgpt: CGPoint){
		var hasx = false
		var hasy = false
		for cons in fview.constraints {
			if cons.firstAttribute == .left {
				cons.constant = orgpt.x
				hasx = true
			} else if cons.firstAttribute == .top {
				cons.constant = orgpt.y
				hasy = true
			}
		}
		if !hasx {
			let xcons = NSLayoutConstraint(item: fview, attribute: .left, relatedBy: .equal, toItem: tview, attribute: .left, multiplier: 1.0, constant: orgpt.x)
			fview.addConstraint(xcons)
		}
		if !hasy {
			let ycons = NSLayoutConstraint(item: fview, attribute: .top, relatedBy: .equal, toItem: tview, attribute: .top, multiplier: 1.0, constant: orgpt.y)
			fview.addConstraint(ycons)
		}
	}

	public class func setFixedSizeConstraint(target view: KCViewBase, size sz: CGSize){
		var haswidth  = false
		var hasheight = false
		for cons in view.constraints {
			if cons.firstAttribute == .width {
				NSLog("Update width: \(sz.description)")
				cons.constant = sz.width
				haswidth  = true
			} else if cons.firstAttribute == .height {
				NSLog("Update height: \(sz.description)")
				cons.constant = sz.height
				hasheight = true
			}
		}
		if !haswidth {
			NSLog("Allocate width: \(sz.description)")
			let wcons = NSLayoutConstraint(item: view, attribute: .width,  relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: sz.width)
			view.addConstraint(wcons)
		}
		if !hasheight {
			NSLog("Allocate height: \(sz.description)")
			let hcons = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: sz.height)
			view.addConstraint(hcons)
		}
	}

	/* Original: https://www.hackingwithswift.com/example-code/uikit/how-to-find-the-view-controller-responsible-for-a-view */
	public func findViewController() -> KCViewController? {
	    if let nextResponder = self.next as? KCViewController {
		return nextResponder
	    } else if let nextResponder = self.next as? KCView {
		return nextResponder.findViewController()
	    } else {
		return nil
	    }
	}

	/*
	 * XIB load support
	 */
	public func loadChildXib(thisClass tc: AnyClass, nibName nn: String) -> KCView {
		let bundle : Bundle = Bundle(for: tc) ;
		#if os(iOS)
			let nib = UINib(nibName: nn, bundle: bundle)
			let views = nib.instantiate(withOwner: nil, options: nil)
			for view in views {
				if let v = view as? KCView {
					return v ;
				}
			}
		#else
			if let nib = NSNib(nibNamed: nn, bundle: bundle) {
				var viewsp : NSArray? = NSArray()
				if(nib.instantiate(withOwner: nil, topLevelObjects: &viewsp)){
					if let views = viewsp {
						for view in views {
							if let v = view as? KCView {
								return v ;
							}
						}
					}
				}
			}
		#endif
		fatalError("Failed to load " + nn)
	}

	public func searchSubViewByType<T>(view v: KCViewBase) -> T? {
		for subview in v.subviews {
			if let targetview = subview as? T {
				return targetview
			}
		}
		return nil
	}

	/*
	 * Visitor
	 */
	open func accept(visitor vis: KCViewVisitor){
		CNLog(logLevel: .error, message: "Unaccepted visitor in KCViewVisitor: \(vis)")
	}
}

