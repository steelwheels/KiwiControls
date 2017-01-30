/**
* @file		KCRepetitiveImagesLayer.swift
* @brief	Define KCRepetitiveImagesLayer class
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import Foundation
import KiwiGraphics

public class KCRepetitiveImagesLayer: KCLayer
{
	private var mElementSize	: CGSize
	private var mElementOrigins	: Array<CGPoint>

	public init(frame f: CGRect,
	            elementSize es: CGSize,
	            elementOrigins eo: Array<CGPoint>,
	            elementDrawer ed: @escaping KGImageDrawer)
	{
		mElementSize	= es
		mElementOrigins	= eo
		super.init(frame: f)
		for origin in eo {
			//Swift.print("repetitive: allocate layers")
			let suborigin = calcOrigin(elementOrigin: origin, elementSize: es, entireFrame: f)
			let subframe  = CGRect(origin: suborigin, size: es)
			let sublayer  = KCImageDrawerLayer(frame: subframe, drawer: ed)
			self.addSublayer(sublayer)
			sublayer.setNeedsDisplay()
		}
	}

	private func calcOrigin(elementOrigin elmorg: CGPoint, elementSize elmsz: CGSize, entireFrame frame: CGRect) -> CGPoint {
		let origin: CGPoint
		let xpos = frame.size.width  * elmorg.x
		let ypos = frame.size.height * elmorg.y
		#if os(iOS)
			origin = CGPoint(x: xpos, y: frame.size.height - ypos - elmsz.height)
		#else
			origin = CGPoint(x: xpos, y: ypos)
		#endif
		return origin
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


