//
//  ViewController.swift
//  UTGraphicsView
//
//  Created by Tomoo Hamada on 2016/11/23.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiGraphics
import KiwiControls

private class UTVertexDrawer
{
	private var mEclipse:	KGEclipse
	private var mGradient:	CGGradient

	public init(bounds b: CGRect, color c: CGColor){
		let center = b.center
		let radius = min(b.size.width, b.size.height)/2.0
		mEclipse  = KGEclipse(center: center, innerRadius: radius*0.5, outerRadius: radius)
		mGradient = KGGradientTable.sharedGradientTable.gradient(forColor: c)
	}

	public func drawContent(context ctxt:CGContext){
		ctxt.setStrokeColor(KGColorTable.white.cgColor)
		ctxt.draw(eclipse: mEclipse, withGradient: mGradient)
	}
}

class ViewController: UIViewController
{

	@IBOutlet weak var mGraphicsView: KCGraphicsView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	public override func viewDidLayoutSubviews() {

		Swift.print("View did layout")
		let bounds     = mGraphicsView.bounds

		/* Background layer */
		let background = KCBackgroundLayer(frame: bounds)
		background.color = KGColorTable.black.cgColor
		mGraphicsView.rootLayer.addSublayer(background)
		let backdesc = background.layerDescription()
		print("background: \(backdesc)")

		/* Graphics layer */
		let graphics = KCGraphicsLayer(frame: bounds, drawer: {
			(size: CGSize, context: CGContext) -> Void in
				Swift.print("Graphics Layer: draw in size:\(size.description) bounds:\(bounds.description)")
				let bounds = CGRect(origin: CGPoint.zero, size: size)
				let vertex = UTVertexDrawer(bounds: bounds, color: KGColorTable.blue.cgColor)
				vertex.drawContent(context: context)
		})
		//graphics.backgroundColor = KGColorTable.red.cgColor
		mGraphicsView.rootLayer.addSublayer(graphics)

		/* Repetitive layer */
		let glyph = KGGlyph(bounds: bounds)
		let eradius = glyph.elementRadius
		let esize = CGSize(width: eradius*2.0, height: eradius*2.0)
		let repetitive = KCRepetitiveLayer(frame: bounds, elementSize: esize, elementDrawer: {
			(size: CGSize, context: CGContext) -> Void in
			let bounds = CGRect(origin: CGPoint.zero, size: size)
			let vertex = UTVertexDrawer(bounds: bounds, color: KGColorTable.yellow.cgColor)
			vertex.drawContent(context: context)
		})
		for vertex in glyph.vertices {
			let mvertex = CGPoint(x: vertex.x-eradius, y: vertex.y-eradius)
			repetitive.add(location: mvertex)
		}
		mGraphicsView.rootLayer.addSublayer(repetitive)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}


