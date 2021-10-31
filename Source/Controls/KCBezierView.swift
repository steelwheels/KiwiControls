/*
 * @file	KCBezierView.swift
 * @brief	Define KCBezierView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 * @par Reference
 *   https://stackoverflow.com/questions/47738822/simple-drawing-with-mouse-on-cocoa-swift
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCBezierView: KCView
{
	private var mBezierPath:	CNBezierPath

	public override init(frame: KCRect) {
		mBezierPath = CNBezierPath()
		super.init(frame: frame)
	}

	required public init?(coder: NSCoder) {
		mBezierPath = CNBezierPath()
		super.init(coder: coder)
	}

	public var lineWidth: CGFloat {
		get	    { return mBezierPath.lineWidth	}
		set(newval) { mBezierPath.lineWidth = newval 	}
	}

	public override func acceptMouseEvent(mouseEvent event:KCMouseEvent, mousePosition position:CGPoint){
		switch event {
		case .down:
			mBezierPath.addDown(point: position, in: self.frame.size)
		case .up:
			mBezierPath.addUp(point: position, in: self.frame.size)
		case .drag:
			mBezierPath.addDown(point: position, in: self.frame.size)
		}
		self.requireDisplay()
	}

	public override func draw(_ dirtyRect: KCRect) {
		let frame  = self.frame
		let bezier = KCBezierPath(rect: frame)
		bezier.lineJoinStyle = .round
		bezier.lineCapStyle  = .round
		bezier.lineWidth     = mBezierPath.lineWidth
		mBezierPath.forEach({
			(_ point: CNBezierPath.Path) -> Void in
			switch point {
			case .moveTo(let lpt):
				let ppt = logicalToPhysical(point: lpt, in: frame)
				bezier.move(to: ppt)
			case .lineTo(let lpt):
				let ppt = logicalToPhysical(point: lpt, in: frame)
				bezier.addLine(to: ppt)
			case .lineWidth(let wid):
				bezier.lineWidth = wid
			@unknown default:
				CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			}
		})
		bezier.stroke()
	}

	private func logicalToPhysical(point pt: CGPoint, in rect: CGRect) -> CGPoint {
		let x = pt.x * rect.size.width  + rect.origin.x
		let y = pt.y * rect.size.height + rect.origin.y
		return CGPoint(x: x, y: y)
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(bezierView: self)
	}
}

/*


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

@IBOutlet weak var window: NSWindow!

func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    let view = DrawView()
    view.translatesAutoresizingMaskIntoConstraints = false
    self.window.contentView?.addSubview(view)

    self.window.contentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": view]))
    self.window.contentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": view]))
}

func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
}

}

class DrawView: NSView {
var path: NSBezierPath = NSBezierPath()

override func mouseDown(with event: NSEvent) {
    path.move(to: convert(event.locationInWindow, from: nil))
    needsDisplay = true
}

override func mouseDragged(with event: NSEvent) {
    path.line(to: convert(event.locationInWindow, from: nil))
    needsDisplay = true
}

override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)

    NSColor.black.set()

    path.lineJoinStyle = .roundLineJoinStyle
    path.lineCapStyle = .roundLineCapStyle
    path.lineWidth = 10.0
    path.stroke()
}
}
*/

