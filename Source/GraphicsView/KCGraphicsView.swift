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
	private var areaToBeDisplay = CGRect.zero

	public func setup(){
		self.layer = KCLayer(frame: bounds)
	}

	public var rootLayer: KCLayer {
		get {
			if let layer = self.layer as? KCLayer {
				return layer
			} else {
				fatalError("No valid layer")
			}
		}
	}

	#if os(iOS)
	public override func draw(_ dirtyRect: CGRect){
		super.draw(dirtyRect)
		//drawContext(dirtyRect: dirtyRect)
		areaToBeDisplay = CGRect.zero
	}
	#else
	public override func draw(_ dirtyRect: NSRect){
		super.draw(dirtyRect)
		//drawContext(dirtyRect: dirtyRect)
		areaToBeDisplay = CGRect.zero
	}
	#endif

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
		acceptMouseEvent(mouseEvent: .down,mousePosition: pos)
	}
	#else
	public override func mouseDown(with event: NSEvent) {
		let pos = eventLocation(event: event)
		acceptMouseEvent(mouseEvent: .down,mousePosition: pos)
	}
	#endif

	#if os(iOS)
	public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let pos = eventLocation(touches: touches)
		acceptMouseEvent(mouseEvent: .drag,mousePosition: pos)
	}
	#else
	public override func mouseDragged(with event: NSEvent) {
		let pos = eventLocation(event: event)
		acceptMouseEvent(mouseEvent: .drag,mousePosition: pos)
	}
	#endif

	#if os(iOS)
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let pos = eventLocation(touches: touches)
		acceptMouseEvent(mouseEvent: .up,mousePosition: pos)
	}
	#else
	public override func mouseUp(with event: NSEvent) {
		let pos = eventLocation(event: event)
		acceptMouseEvent(mouseEvent: .up,mousePosition: pos)
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

	private func acceptMouseEvent(mouseEvent event:KCMouseEvent, mousePosition position:CGPoint){
		if let toplayer = self.layer as? KCLayer {
			let urect = toplayer.mouseEvent(event: event, at: position)
			if !urect.isEmpty {
				//Swift.print("update: \(res.updateArea.description)")
				#if os(iOS)
					let uparea = convertCoodinate(sourceRect: urect, bounds: bounds)
					setNeedsDisplay(uparea)
				#else
					setNeedsDisplay(urect)
				#endif
			}
		}
	}	
}


