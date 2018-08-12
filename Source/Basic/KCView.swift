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
	#if os(iOS)
	public static let noIntrinsicMetric = UIViewNoIntrinsicMetric
	#endif

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
	public func setFixedSizeForLayout(size sz: KCSize, spacing space: CGFloat)
	{
		self.translatesAutoresizingMaskIntoConstraints = false
		let vconst = NSLayoutConstraint(item: self,
						attribute: .height,
						relatedBy: .equal,
						toItem: nil,
						attribute: .height,
						multiplier: 1.0,
						constant: sz.height)
		let hconst = NSLayoutConstraint(item: self,
						attribute: .width,
						relatedBy: .equal,
						toItem: nil,
						attribute: .width,
						multiplier: 1.0,
						constant: sz.width)
		addConstraint(vconst)
		addConstraint(hconst)
	}

	public func allocateSubviewLayout(subView sview: KCViewBase){
		sview.translatesAutoresizingMaskIntoConstraints = false
		addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.top)) ;
		addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.left)) ;
		addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.bottom)) ;
		addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.right)) ;
	}

	public func allocateSubviewLayout(subView sview: KCViewBase, forVerical vert: Bool){
		if vert {
			addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.top)) ;
			addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.bottom)) ;
		} else {
			addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.left)) ;
			addConstraint(allocateLayout(subView: sview, attribute: KCLayoutAttribute.right)) ;
		}
	}

	private func allocateLayout(subView sview : KCViewBase, attribute attr: KCLayoutAttribute) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: self, attribute: attr, relatedBy: KCLayoutRelation.equal, toItem: sview, attribute: attr, multiplier: 1.0, constant: 0.0) ;
	}

	/*
	 * XIB load support
	 */
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

	public func setResizePriority(doGrowHorizontally horiz: Bool, doGrowVertically vert: Bool){
		if horiz {
			setContentHuggingPriority(.defaultLow, for: .horizontal)
		} else {
			setContentHuggingPriority(.defaultHigh, for: .horizontal)
		}
		setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

		if vert {
			setContentHuggingPriority(.defaultLow, for: .vertical)
		} else {
			setContentHuggingPriority(.defaultHigh, for: .vertical)
		}
		setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
	}

	/*
	 * Visitor
	 */
	open func accept(visitor vis: KCViewVisitor){
		NSLog("Unaccepted visitor in KCViewVisitor: \(vis)")
	}
}

