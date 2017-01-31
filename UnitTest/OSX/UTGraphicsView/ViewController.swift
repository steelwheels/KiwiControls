//
//  ViewController.swift
//  UTGraphicsView
//
//  Created by Tomoo Hamada on 2016/09/18.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import KiwiGraphics
import Cocoa

private class UTVertexDrawer
{
	private var mEclipse:	KGEclipse
	private var mGradient:	CGGradient

	public init(bounds b: CGRect, color c: CGColor){
		let center = b.center
		let radius = min(b.size.width, b.size.height)/2.0
		mEclipse  = KGEclipse(center: center, innerRadius: radius*0.5, outerRadius: radius)
		mGradient = KGGradientTable.sharedGradientTable.Gradient(forColor: c)
	}

	public func drawContent(context ctxt:CGContext){
		ctxt.setStrokeColor(KGColorTable.black.cgColor)
		ctxt.draw(eclipse: mEclipse, withGradient: mGradient)
	}
}

class ViewController: KCViewController {

	@IBOutlet weak var mGraphicsView: KCLayerView!

	private var mStrokeDrawer: KCStrokeDrawerLayer? = nil

	override func viewDidLoad() {
		Swift.print("View did load")
		super.viewDidLoad()
	}

	override func viewDidLayout() {
		Swift.print("View did layout")

		// Do any additional setup after loading the view.
		let bounds     = mGraphicsView.bounds

		/* Background layer */
		let background = KCBackgroundLayer(frame: bounds, color: KGColorTable.black.cgColor)
		mGraphicsView.rootLayer.addSublayer(background)

		/* Image layer */
		let idrawer = KCImageDrawerLayer(frame: bounds, drawer: {
			(context: CGContext, size: CGSize) -> Void in
			Swift.print("KCImageDrawerLayer: bounds:\(size.description)")
			let bounds = CGRect(origin: CGPoint.zero, size: size)
			let vertex = UTVertexDrawer(bounds: bounds, color: KGColorTable.white.cgColor)
			vertex.drawContent(context: context)
		})
		background.addSublayer(idrawer)
		//mGraphicsView.rootLayer.addSublayer(idrawer)
		idrawer.setNeedsDisplay()
		
		/* Repetitive layer */
		var origins: Array<CGPoint> = []
		for i in 0..<10 {
			let p = Double(i) * 0.1
			origins.append(CGPoint(x: p, y: p))
		}
		Swift.print("repetitive: \(origins)")
		let repetitive = KCRepetitiveImagesLayer(frame: bounds,
		                                         elementSize: CGSize(width: 30, height: 30),
		                                         elementOrigins: origins,
		                                         elementDrawer: {
			(context: CGContext, size: CGSize) -> Void in
			Swift.print("KRepetitiverLayer: bounds:\(size.description)")
			let elmbounds = CGRect(origin: CGPoint.zero, size: size)
			let vertex = UTVertexDrawer(bounds: elmbounds, color: KGColorTable.gray.cgColor)
			vertex.drawContent(context: context)
		})
		idrawer.addSublayer(repetitive)
		repetitive.setNeedsDisplay()

		/* Stroke drawer */
		let sdrawer = KCStrokeDrawerLayer(frame: bounds)
		sdrawer.lineWidth = 10.0
		sdrawer.lineColor = KGColorTable.yellow.cgColor
		sdrawer.stroke = [CGPoint(x:0.0, y:0.0), CGPoint(x:100, y:100), CGPoint(x:150, y:100), CGPoint(x:200, y:200)]
		repetitive.addSublayer(sdrawer)
		sdrawer.setNeedsDisplay()
		mStrokeDrawer = sdrawer

		/* Animation */
		let timer = KCTimer()
		timer.updateCallback = {
			(time:TimeInterval) -> Bool in
			if let drawer = self.mStrokeDrawer {
				let center = drawer.bounds.center

				let cosv = CGFloat(cos(Double(time)) * 80.0)
				let sinv = CGFloat(sin(Double(time)) * 80.0)
				let endpt = CGPoint(x: center.x + cosv, y: center.y + sinv)
				drawer.stroke = [CGPoint(x:center.x, y:center.y), endpt]
			}
			return true /* continue */
		}
		timer.start(startValue: 0.0, stopValue: 10.0, stepValue: 0.4)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

