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

open class KCView : KCViewBase
{
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

	#if os(iOS)
	open override func draw(_ dirtyRect: CGRect){
		super.draw(dirtyRect)
		//drawContext(dirtyRect: dirtyRect)
		areaToBeDisplay = CGRect.zero
	}
	#else
	open override func draw(_ dirtyRect: NSRect){
	super.draw(dirtyRect)
		//drawContext(dirtyRect: dirtyRect)
		areaToBeDisplay = CGRect.zero
	}
	#endif

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
	 *
	 */
	public class func unionHolizontalIntrinsicSizes(left s0: KCSize, right s1: KCSize) -> KCSize
	{
		let padding: CGFloat = 8.0
		let width: CGFloat
		if s0.width > 0.0 && s1.width > 0.0 {
			width = s0.width + padding + s1.width
		} else {
			width = -1.0
		}
		let height: CGFloat
		if s0.height > 0.0 && s1.height > 0.0 {
			height  = max(s0.height, s1.height)
		} else {
			height = -1.0
		}
		return KCSize(width: width, height: height)
	}

	public class func unionVerticalIntrinsicSizes(top s0: KCSize, bottom s1: KCSize) -> KCSize
	{
		let padding: CGFloat = 8.0
		let width: CGFloat
		if s0.width > 0.0 && s1.width > 0.0 {
			width = max(s0.width, s1.width)
		} else {
			width = -1.0
		}
		let height: CGFloat
		if s0.height > 0.0 && s1.height > 0.0 {
			height  = s0.height + padding + s1.height
		} else {
			height = -1.0
		}
		return KCSize(width: width, height: height)
	}
	
	/*
	 * XIB load support 
	 */
	private func allocateLayout(subView sview : KCViewBase, attribute attr: KCLayoutAttribute) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: self, attribute: attr, relatedBy: KCLayoutRelation.equal, toItem: sview, attribute: attr, multiplier: 1.0, constant: 0.0) ;
	}

	public func allocateSubviewLayout(subView sview: KCViewBase){
		sview.translatesAutoresizingMaskIntoConstraints = false
		addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.top)) ;
		addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.left)) ;
		addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.bottom)) ;
		addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.right)) ;
	}

	public func loadChildXib(thisClass tc: AnyClass, nibName nn: String) -> KCView {
		let bundle : Bundle = Bundle(for: tc) ;
		#if os(iOS)
			let nib = UINib(nibName: nn, bundle: bundle)
			let views = nib.instantiate(withOwner: nil, options: nil)
			for i in 0..<views.count {
				if let view = views[i] as? KCView {
					view.frame = self.bounds ;
					addSubview(view) ;
					return view ;
				}
			}
		#else
			if let nib = NSNib(nibNamed: NSNib.Name(rawValue: nn), bundle: bundle) {
				var viewsp : NSArray? = NSArray()
				if(nib.instantiate(withOwner: nil, topLevelObjects: &viewsp)){
					if let views = viewsp {
						for i in 0..<views.count {
							if let view = views[i] as? KCView {
								view.frame = self.bounds ;
								addSubview(view) ;
								return view ;
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

	public func setTransparentView(){
		#if os(iOS)
		self.isOpaque = false
		self.backgroundColor = UIColor.clear
		self.clearsContextBeforeDrawing = false
		#endif
	}

	open func printDebugInfo(indent idt: Int) {
		KCPrintDebugInfo(view: self, indent: idt)
	}
}

/*
 * Debug information
 */
public func KCPrintDebugInfo(view v: KCViewBase, indent idt: Int){
	#if os(iOS)
		let name = NSStringFromClass(type(of: v))
	#else
		let name = v.className
	#endif

	let contentsize = v.intrinsicContentSize

	let hhugging  = v.contentHuggingPriority(for: .horizontal)
	let vhugging  = v.contentHuggingPriority(for: .vertical)
	let hcompress = v.contentCompressionResistancePriority(for: .horizontal)
	let vcompress = v.contentCompressionResistancePriority(for: .vertical)

	KCPrintIndent(indent: idt) ; Swift.print("[\(name)]")
	KCPrintIndent(indent: idt) ; Swift.print("- frame : \(v.frame.description)")
	KCPrintIndent(indent: idt) ; Swift.print("- bounds: \(v.bounds.description)")
	KCPrintIndent(indent: idt) ; Swift.print("- intrinsicContentSize: \(contentsize.description)")
	KCPrintIndent(indent: idt) ; Swift.print("- translatesAutoresizingMaskIntoConstraints: \(v.translatesAutoresizingMaskIntoConstraints)")
	KCPrintIndent(indent: idt) ; Swift.print("- contentHuggingPriority: [holiz] \(hhugging), [vert] \(vhugging)")
	KCPrintIndent(indent: idt) ; Swift.print("- contentCompressionResistancePriority: [holiz] \(hcompress), [vert] \(vcompress)")
}

public func KCPrintIndent(indent idt: Int){
	for _ in 0..<idt {
		Swift.print("  ", terminator:"")
	}
}

