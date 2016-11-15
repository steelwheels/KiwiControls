/**
 * @file	KCGraphicsView.swift
 * @brief	Define KCGraphicsView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import KiwiGraphics

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

private func convertCoodinate(sourceRect r: CGRect, bounds b: CGRect) -> CGRect
{
	let y = (b.size.height - (r.size.height + r.origin.y))
	return CGRect(x: r.origin.x, y: y, width: r.size.width, height: r.size.height)
}

public class KCGraphicsView: KCView
{	
	public var drawCallback: ((_ context:CGContext, _ bounds:CGRect, _ dirtyRect:CGRect) -> Void)? = nil
	public var mouseEventCallback: ((_ event: KCMouseEvent, _ point: CGPoint) -> CGRect)? = nil

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

	private func drawContext(dirtyRect drect: CGRect){
		areaToBeDisplay = CGRect.zero
		if let context = currentContext {
			context.saveGState()
			#if os(iOS)
			/* Setup as left-lower-origin */
			let height = self.bounds.size.height
			context.translateBy(x: 0.0, y: height)
			context.scaleBy(x: 1.0, y: -1.0);
			/* Translate coodinate of dirty-rect */
			let mdrect = convertCoodinate(sourceRect: drect, bounds: bounds)
			#else
			let mdrect = drect
			#endif
			if let callback = drawCallback {
				callback(context, bounds, mdrect)
			}
			context.restoreGState()
		}
	}

	private var areaToBeDisplay = CGRect.zero

	public override func setNeedsDisplay(_ invalidRect: KGRect)
	{
		if areaToBeDisplay.isEmpty {
			areaToBeDisplay = invalidRect
		} else {
			areaToBeDisplay = areaToBeDisplay.union(invalidRect)
		}
		super.setNeedsDisplay(areaToBeDisplay)
		//Swift.print("setNeedsDisplay: \(areaToBeDisplay.description)")
	}

	#if os(iOS)
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let pos = eventLocation(touches: touches)
		if let callback = mouseEventCallback {
			let result = callback(.down, pos)
			acceptMouseEventResult(updateRect: result)
		}
	}
	#else
	public override func mouseDown(with event: NSEvent) {
		let pos = eventLocation(event: event)
		if let callback = mouseEventCallback {
			let result = callback(.down, pos)
			acceptMouseEventResult(result: result)
		}
	}
	#endif

	#if os(iOS)
	public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let pos = eventLocation(touches: touches)
		if let callback = mouseEventCallback {
			let result = callback(.drag, pos)
			acceptMouseEventResult(updateRect: result)
		}
	}
	#else
	public override func mouseDragged(with event: NSEvent) {
		let pos = eventLocation(event: event)
		if let callback = mouseEventCallback {
			let result = callback(.drag, pos)
			acceptMouseEventResult(updateRect: result)
		}
	}
	#endif

	#if os(iOS)
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let pos = eventLocation(touches: touches)
		if let callback = mouseEventCallback {
			let result = callback(.up, pos)
			acceptMouseEventResult(updateRect: result)
		}
	}
	#else
	public override func mouseUp(with event: NSEvent) {
		let pos = eventLocation(event: event)
		if let callback = mouseEventCallback {
			let result = callback(.up, pos)
			acceptMouseEventResult(updateRect: result)
		}
	}
	#endif

	#if os(iOS)
	private func eventLocation(touches tchs: Set<UITouch>) -> CGPoint {
		if let touch = tchs.first {
			let pos = touch.location(in: self)
			return convertCoodinate(sourcePoint: pos, bounds: bounds)
		} else {
			fatalError("No touch location")
		}
	}
	#else
	private func eventLocation(event evt: NSEvent) -> CGPoint {
		let pos = convert(evt.locationInWindow, to: nil)
		return convert(pos, to: nil)
	}
	#endif

	private func acceptMouseEventResult(updateRect urect: CGRect){
		if !urect.isEmpty {
			//Swift.print("update: \(res.updateArea.description)")
			#if os(iOS)
				let uparea = convertCoodinate(sourceRect: urect, bounds: bounds)
				setNeedsDisplay(uparea)
			#else
				setNeedsDisplay(res.updateArea)
			#endif
		}
	}
}


