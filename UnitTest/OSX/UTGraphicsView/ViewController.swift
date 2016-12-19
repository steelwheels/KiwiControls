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
		mGradient = KGGradientTable.sharedGradientTable.gradient(forColor: c)
	}

	public func drawContent(context ctxt:CGContext){
		ctxt.setStrokeColor(KGColorTable.white.cgColor)
		ctxt.draw(eclipse: mEclipse, withGradient: mGradient)
	}
}

class ViewController: KCViewController {

	@IBOutlet weak var mGraphicsView: KCLayerView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		Swift.print("View did load")

		/* Background layer */
		let bounds     = mGraphicsView.bounds
		let background = KCBackgroundLayer(frame: bounds)
		background.color = KGColorTable.aliceBlue.cgColor
		mGraphicsView.rootLayer.addSublayer(background)
		let backdesc = background.layerDescription()
		print("background: \(backdesc)")
		
		/* Graphics layer */
		let graphics = KCGraphicsLayer(frame: bounds, drawer: {
			(size: CGSize, context: CGContext) -> Void in
				Swift.print("Graphics Layer: bounds:\(bounds.description)")
				let bounds = CGRect(origin: CGPoint.zero, size: size)
				let vertex = UTVertexDrawer(bounds: bounds, color: KGColorTable.blue.cgColor)
				vertex.drawContent(context: context)
		})
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

		/* Text font */
		let font:NSFont = NSFont.systemFont(ofSize: NSFont.systemFontSize())
		let textbounds = KGAlignRect(holizontalAlignment: .center,
		                             verticalAlignment: .top,
		                             targetSize: CGSize(width: bounds.size.width, height: 40.0),
		                             in: bounds)
		let textcolor = KGColorTable.red.cgColor
		let text = KCTextLayer(frame: textbounds, font: font, color: textcolor, text: "Hello, world")
		mGraphicsView.rootLayer.addSublayer(text)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

