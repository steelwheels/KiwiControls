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
import KiwiGraphics
import Canary

#if os(iOS)
	public typealias KCViewBase = UIView
#else
	public typealias KCViewBase = NSView
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
	/*
	 * Thread control
	 */
	public func executeInMainThread(execute exec: () -> Void){
		if Thread.isMainThread {
			exec()
		} else {
			DispatchQueue.main.sync(execute: exec)
		}
	}

	/*
	 * Debug information
	 */
	open func printDebugInfo(indent idt: Int){
		#if os(iOS)
			let name = NSStringFromClass(type(of: self))
		#else
			let name = self.className
		#endif

		printIndent(indent: idt) ; Swift.print("[\(name)]")
		printIndent(indent: idt) ; Swift.print("- frame : \(self.frame.description)")
		printIndent(indent: idt) ; Swift.print("- bounds: \(self.bounds.description)")
	}

	public func printIndent(indent idt: Int){
		for _ in 0..<idt {
			Swift.print("  ", terminator:"")
		}
	}
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

	open override func setNeedsDisplay(_ invalidRect: KGRect)
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
	 * XIB load support 
	 */
	private func allocateLayout(subView sview : KCViewBase, attribute attr: NSLayoutAttribute) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: self, attribute: attr, relatedBy: NSLayoutRelation.equal, toItem: sview, attribute: attr, multiplier: 1.0, constant: 0.0) ;
	}

	public func allocateSubviewLayout(subView sview: KCViewBase){
		sview.translatesAutoresizingMaskIntoConstraints = false
		addConstraint(allocateLayout(subView: sview, attribute: NSLayoutAttribute.top)) ;
		addConstraint(allocateLayout(subView: sview, attribute: NSLayoutAttribute.left)) ;
		addConstraint(allocateLayout(subView: sview, attribute: NSLayoutAttribute.bottom)) ;
		addConstraint(allocateLayout(subView: sview, attribute: NSLayoutAttribute.right)) ;
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
			if let nib = NSNib(nibNamed: nn, bundle: bundle) {
				var views : NSArray = NSArray()
				if(nib.instantiate(withOwner: nil, topLevelObjects: &views)){
					for i in 0..<views.count {
						if let view = views[i] as? KCView {
							view.frame = self.bounds ;
							addSubview(view) ;
							return view ;
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
}


