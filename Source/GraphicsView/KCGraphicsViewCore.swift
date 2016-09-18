/**
 * @file	KCGraphicsViewCore.h
 * @brief	Define KCGraphicsViewCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import Cocoa

public class KCGraphicsViewCore: KCView
{
	@IBOutlet weak var mGraphicsView: NSView!
	
	public var drawCallback: ((_ context:CGContext, _ bounds:CGRect, _ dirtyRect:CGRect) -> Void)? = nil

	public func setOriginPosition(){
		if let grcontext = NSGraphicsContext.current() {
			let context = grcontext.cgContext
			
			/* Setup as left-lower-origin */
			let height = self.bounds.size.height
			context.translateBy(x: 0.0, y: height);
			context.scaleBy(x: 1.0, y: -1.0);
		}
	}

	public override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		if let grcontext = NSGraphicsContext.current() {
			let cgcontext = grcontext.cgContext
			cgcontext.saveGState()
			if let callback = drawCallback {
				callback(cgcontext, bounds, dirtyRect)
			}
			cgcontext.restoreGState()
		}
	}
}

