//
//  ViewController.swift
//  UTLayer
//
//  Created by Tomoo Hamada on 2016/11/19.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import CoreGraphics
import KiwiGraphics

class ViewController: NSViewController
{
	@IBOutlet weak var mImageView: NSImageView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let bounds = mImageView.bounds
		let image = NSImage.generate(size: bounds.size, drawFunc: {
			(size: CGSize, context: CGContext) -> Void in
				drawVertex(size: size, context: context)
		})
		mImageView.image = image
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	private func drawVertex(size sz: CGSize, context ctxt: CGContext) -> Void {
		let bounds = CGRect(origin: CGPoint.zero, size: sz)
		let center = bounds.center
		let radius = min(sz.width, sz.height)/2.0
		let eclipse  = KGEclipse(center: center, innerRadius: radius*0.5, outerRadius: radius)
		let gradient = KGGradientTable.sharedGradientTable.gradient(forColor: KGColorTable.black.cgColor)

		ctxt.draw(eclipse: eclipse, withGradient: gradient)
	}

}

/*
private class UTVertexDrawer: KCGraphicsLayer
{
	private var mEclipse:	KGEclipse
	private var mGradient:	CGGradient

	public init(bounds b: CGRect, color c: CGColor){
		let center = b.center
		let radius = min(b.size.width, b.size.height)/2.0
		mEclipse  = KGEclipse(center: center, innerRadius: radius*0.5, outerRadius: radius)
		mGradient = KGGradientTable.sharedGradientTable.gradient(forColor: c)
		super.init(bounds: b)
	}

	public override func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
		if bnd.intersects(drect) {
			ctxt.setStrokeColor(KGColorTable.white.cgColor)
			ctxt.draw(eclipse: mEclipse, withGradient: mGradient)
		}
	}
}
*/
