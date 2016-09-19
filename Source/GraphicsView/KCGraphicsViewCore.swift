/**
 * @file	KCGraphicsViewCore.h
 * @brief	Define KCGraphicsViewCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif

public class KCGraphicsViewCore: KCView
{
	#if os(iOS)
	@IBOutlet weak var mGraphicsView: UIView!
	#else
	@IBOutlet weak var mGraphicsView: NSView!
	#endif
	
	public var drawCallback: ((_ context:CGContext, _ bounds:CGRect, _ dirtyRect:CGRect) -> Void)? = nil

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

	private func drawContext(dirtyRect drect: CGRect){
		if let context = currentContext {
			context.saveGState()
			if let callback = drawCallback {
				callback(context, bounds, drect)
			}
			context.restoreGState()
		}
	}
}

