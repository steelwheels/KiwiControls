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
		ctxt.setStrokeColor(KGColorTable.black.cgColor)
		ctxt.draw(eclipse: mEclipse, withGradient: mGradient)
	}
}

class ViewController: KCViewController {

	@IBOutlet weak var mGraphicsView: KCLayerView!
	@IBOutlet weak var mSymbol0View: KCLayerView!
	@IBOutlet weak var mSymbol1View: KCLayerView!
	@IBOutlet weak var mSymbol2View: KCLayerView!
	@IBOutlet weak var mSymbol3View: KCLayerView!
	@IBOutlet weak var mSelectionView: KCLayerView!

	private var mStrokeDrawer:	KCStrokeDrawerLayer? = nil
	private var mSelectionLayer:	KCSelectionLayer? = nil

	override func viewDidLoad() {
		Swift.print("View did load")
		super.viewDidLoad()

	}

	override func viewDidLayout() {
		Swift.print("View did layout")
		setupGraphicsView()
		setupSymbolView(layerView: mSymbol0View, symbolId: 0)
		setupSymbolView(layerView: mSymbol1View, symbolId: 1)
		setupSymbolView(layerView: mSymbol2View, symbolId: 2)
		setupSymbolView(layerView: mSymbol3View, symbolId: 3)
		setupSelectionView(layerView: mSelectionView)
	}

	private func setupSymbolView(layerView lview: KCLayerView, symbolId sid: Int)
	{
		Swift.print("setupSymbolView: \(sid)")

		/* Background layer */
		let symbolbounds = lview.bounds
		let background = KCBackgroundLayer(frame: symbolbounds, color: KGColorTable.black.cgColor)
		lview.rootLayer.addSublayer(background)

		let drawrect    = CGRect(origin: CGPoint.zero, size: symbolbounds.size)
		let symbolLayer = UTAllocateSymbol(symbolId: sid, frame: symbolbounds, drawRect: drawrect)
		background.addSublayer(symbolLayer)
	}

	private func setupSelectionView(layerView lview: KCLayerView)
	{
		/* Background layer */
		let symbolbounds = lview.bounds
		let background = KCBackgroundLayer(frame: symbolbounds, color: KGColorTable.black.cgColor)
		lview.rootLayer.addSublayer(background)

		/* Selection layer */
		let selection = KCSelectionLayer(frame: symbolbounds)
		for i in 0...3 {
			let drawrect    = CGRect(origin: CGPoint.zero, size: symbolbounds.size)
			let symbol = UTAllocateSymbol(symbolId: i, frame: symbolbounds, drawRect: drawrect)
			selection.addSublayer(symbol)
		}
		selection.visibleIndex = 0
		mSelectionLayer = selection
		background.addSublayer(selection)
	}

	private func setupGraphicsView()
	{
		// Do any additional setup after loading the view.
		let bounds     = mGraphicsView.bounds

		/* Background layer */
		let background = KCBackgroundLayer(frame: bounds, color: KGColorTable.black.cgColor)
		mGraphicsView.rootLayer.addSublayer(background)

		/* Image layer */
		let drawrect    = CGRect(origin: CGPoint.zero, size: bounds.size)
		let idrawer = KCImageDrawerLayer(frame: bounds, drawRect: drawrect, drawer: {
			(context: CGContext, size: CGSize) -> Void in
			//Swift.print("KCImageDrawerLayer: bounds:\(size.description)")
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
			let x = bounds.size.width  / 10.0 * CGFloat(i)
			let y = bounds.size.height / 10.0 * CGFloat(i)
			origins.append(CGPoint(x: x, y: y))
		}
		Swift.print("repetitive: \(origins)")
		let repetitive = KCRepetitiveLayer(frame: bounds,
						   elementSize: CGSize(width: 30, height: 30),
						   elementOrigins: origins,
						   elementDrawer: {
			(context: CGContext, size: CGSize) -> Void in
			//Swift.print("KRepetitiverLayer: bounds:\(size.description)")
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
		sdrawer.strokes = [CGPoint(x:0.0, y:0.0), CGPoint(x:100, y:100), CGPoint(x:150, y:100), CGPoint(x:200, y:200)]
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
				drawer.strokes = [CGPoint(x:center.x, y:center.y), endpt]
			}
			if let selection = self.mSelectionLayer {
				if selection.visibleIndex == KCSelectionLayer.None {
					selection.visibleIndex = 0
				} else {
					let count = selection.count
					let next  = (selection.visibleIndex + 1) % count
					selection.visibleIndex = next
				}
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

