/**
 * @file	KCGraphicsViewCore.swift
 * @brief	Define KCGraphicsViewCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
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

public struct KCMouseEventResult {
	public var didAccepted: Bool
	public var updateRequired: Bool
	public var updateArea: CGRect

	public init(){
		didAccepted	= false
		updateRequired	= false
		updateArea	= CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
	}

	public init(didAccepted da: Bool, updateRequired ur:Bool, updateArea ua: CGRect){
		didAccepted	= da
		updateRequired	= ur
		updateArea	= ua
	}
}

public class KCGraphicsViewCore: KCView
{
	#if os(iOS)
	@IBOutlet weak var mGraphicsView: UIView!
	#else
	@IBOutlet weak var mGraphicsView: NSView!
	#endif
	
	public var drawCallback: ((_ context:CGContext, _ bounds:CGRect, _ dirtyRect:CGRect) -> Void)? = nil
	public var mouseEventCallback: ((_ event: KCMouseEvent, _ point: CGPoint) -> KCMouseEventResult)? = nil

	public func setOriginPosition(){
		if let context = currentContext {
			/* Setup as left-lower-origin */
			let height = self.bounds.size.height
			context.translateBy(x: 0.0, y: height);
			context.scaleBy(x: 1.0, y: -1.0);
		}
	}

	#if os(iOS)
	public override func draw(_ dirtyRect: CGRect){
		super.draw(dirtyRect)
		drawContext(dirtyRect: dirtyRect)
	}
	#else
	public override func draw(_ dirtyRect: NSRect){
		super.draw(dirtyRect)
		drawContext(dirtyRect: dirtyRect)
	}
	#endif

	private var areaToBeDisplay = CGRect.zero

	public override func setNeedsDisplay(_ invalidRect: NSRect) {
		if areaToBeDisplay.isEmpty {
			areaToBeDisplay = invalidRect
		} else {
			areaToBeDisplay = areaToBeDisplay.union(invalidRect)
		}
		super.setNeedsDisplay(areaToBeDisplay)
		//Swift.print("setNeedsDisplay: \(areaToBeDisplay.description)")
	}

	private func drawContext(dirtyRect drect: CGRect){
		areaToBeDisplay = CGRect.zero
		if let context = currentContext {
			context.saveGState()
			if let callback = drawCallback {
				callback(context, bounds, drect)
			}
			context.restoreGState()
		}
	}

	public override func mouseDown(with event: NSEvent) {
		let pos = eventLocation(event: event)
		if let callback = mouseEventCallback {
			let result = callback(.down, pos)
			acceptMouseEventResult(result: result)
		}
	}

	public override func mouseDragged(with event: NSEvent) {
		let pos = eventLocation(event: event)
		if let callback = mouseEventCallback {
			let result = callback(.drag, pos)
			acceptMouseEventResult(result: result)
		}
	}

	public override func mouseUp(with event: NSEvent) {
		let pos = eventLocation(event: event)
		if let callback = mouseEventCallback {
			let result = callback(.up, pos)
			acceptMouseEventResult(result: result)
		}
	}

	private func eventLocation(event evt: NSEvent) -> CGPoint {
		let pos = convert(evt.locationInWindow, to: nil)
		return convert(pos, to: nil)
	}

	private func acceptMouseEventResult(result res: KCMouseEventResult){
		if res.didAccepted && res.updateRequired {
			setNeedsDisplay(res.updateArea)
			//setNeedsDisplay(bounds)
		}
	}


}


