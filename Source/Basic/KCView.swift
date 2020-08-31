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
#if os(OSX)
	public func setNeedsLayout() {
		self.needsLayout = true
	}

	public func setNeedsUpdateConstraints() {
		self.needsUpdateConstraints = true
	}

	public func setNeedsDisplay(){
		self.needsDisplay = true
	}
#endif
	/* for autolayout */
	public enum ExpansionPriority {
		case High
		case Low
		case Fixed

		public static func sortedPriorities() -> Array<ExpansionPriority> {
			return [.Fixed, .Low, .High]
		}

		public func description() -> String {
			let result: String
			switch self {
			case .High:	result = "high"
			case .Low:	result = "low"
			case .Fixed:	result = "fixed"
			}
			return result
		}
	}

	public func setExpansionPriority(holizontal holiz: ExpansionPriority, vertical vert: ExpansionPriority) {
		let hval = expansionPriorityToValue(expansion: holiz)
		setContentHuggingPriority(hval, for: .horizontal)
		setContentCompressionResistancePriority(hval, for: .horizontal)

		let vval = expansionPriorityToValue(expansion: vert)
		setContentHuggingPriority(vval, for: .vertical)
		setContentCompressionResistancePriority(vval, for: .vertical)
	}

	public func expansionPriority() -> (/* Holizontal */ ExpansionPriority, /* Vertical */ ExpansionPriority) {
		let hval = contentHuggingPriority(for: .horizontal)
		let hpri = valueToExpansionPriority(value: hval)

		let vval = contentHuggingPriority(for: .vertical)
		let vpri = valueToExpansionPriority(value: vval)

		return (hpri, vpri)
	}

	private func expansionPriorityToValue(expansion exp: ExpansionPriority) -> KCLayoutPriority {
		let result: KCLayoutPriority
		switch exp {
		case .Fixed:	result = .required - 1
		case .Low:	result = .defaultHigh
		case .High:	result = .defaultLow
		}
		return result
	}

	private func valueToExpansionPriority(value val: KCLayoutPriority) -> ExpansionPriority {
		let result: ExpansionPriority
		if val >= KCLayoutPriority.required - 1 {
			result = .Fixed
		} else if val >= KCLayoutPriority.defaultHigh {
			result = .High
		} else {
			result = .Low
		}
		return result
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
		let pos = convert(evt.locationInWindow, from: self)
		//Swift.print(" -> event:\(pos.description)")
		let diffpos = pos - self.frame.origin
		return diffpos
	}
	#endif

	open func acceptMouseEvent(mouseEvent event:KCMouseEvent, mousePosition position:CGPoint){
		/* Must be override by sub class */
	}

	/*
	 * Update area control
	 */
	private var areaToBeDisplay = CGRect.zero

	open override func draw(_ dirtyRect: KCRect){
		super.draw(dirtyRect)
		areaToBeDisplay = CGRect.zero
	}

	open override func setNeedsDisplay(_ invalidRect: KCRect)
	{
		if areaToBeDisplay.isEmpty {
			areaToBeDisplay = invalidRect
		} else {
			areaToBeDisplay = areaToBeDisplay.union(invalidRect)
		}
		super.setNeedsDisplay(areaToBeDisplay)
		//Swift.print("setNeedsDisplay: \(areaToBeDisplay.description)")
	}

	/*
	 * layout
	 */
	private var mFixedSize:	KCSize?	= nil

	public var hasFixedSize: Bool {
		get { return mFixedSize != nil }
	}

	open func resize(_ size: KCSize){
		mFixedSize       = size
		self.frame.size  = size
		self.bounds.size = size
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if let s = mFixedSize {
				return s
			} else {
				return KCSize(width: KCView.noIntrinsicValue, height: KCView.noIntrinsicValue)
			}
		}
	}

	open func setExpandability(holizontal holiz: ExpansionPriority, vertical vert: ExpansionPriority) {
		setExpansionPriority(holizontal: holiz, vertical: vert)
	}

	open func expandability() -> (/* Holizontal */ ExpansionPriority, /* Vertical */ ExpansionPriority) {
		return expansionPriority()
	}

	open func rebounds(origin org: KCPoint, size sz: KCSize){
		self.frame.origin  = org
		self.bounds.origin = KCPoint.zero
		resize(sz)
	}

	#if os(OSX)
	open override var fittingSize: KCSize {
		get {
			NSLog("Must be override")
			return KCSize.zero
		}
	}
	#else
	open var fittingSize: KCSize {
		get {
			NSLog("Must be override")
			return KCSize.zero
		}
	}
	#endif

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
					rebounds(origin: self.bounds.origin, size: self.bounds.size)
					//addSubview(v) ;
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
								rebounds(origin: self.bounds.origin, size: self.bounds.size)
								//addSubview(v) ;
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
		NSLog("Unaccepted visitor in KCViewVisitor: \(vis)")
	}
}

