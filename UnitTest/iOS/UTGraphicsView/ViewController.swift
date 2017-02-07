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

	@IBOutlet weak var mGraphicsView: KCLayerView!
	@IBOutlet weak var mSymbol0View: KCLayerView!
	@IBOutlet weak var mSymbol1View: KCLayerView!
	@IBOutlet weak var mSymbol2View: KCLayerView!
	@IBOutlet weak var mSymbol3View: KCLayerView!
	@IBOutlet weak var mSelectionView: KCLayerView!

	private var mSelectionLayer: KCSelectionLayer? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	public override func viewDidLayoutSubviews() {
		setupGraphicsView()
		setupSymbolViews()
		setupSelectionView()
		setupTimer()
	}

	private func setupGraphicsView()
	{
		Swift.print("View did layout")
		let bounds     = mGraphicsView.bounds

		/* Background layer */
		let background = KCBackgroundLayer(frame: bounds, color: KGColorTable.black.cgColor)
		mGraphicsView.rootLayer.addSublayer(background)

		/* Image drawer */
		let drawer = KCImageDrawerLayer(frame: bounds, drawer: {
			(context: CGContext, size: CGSize) -> Void in
			Swift.print("Graphics Layer: draw in size:\(size.description) bounds:\(bounds.description)")
			let bounds = CGRect(origin: CGPoint.zero, size: size)
			let vertex = UTVertexDrawer(bounds: bounds, color: KGColorTable.blue.cgColor)
			vertex.drawContent(context: context)
		})
		background.addSublayer(drawer)
		drawer.setNeedsDisplay()

		/* Repetitive layer */
		let elmsize = CGSize(width: bounds.size.width/10.0, height: bounds.size.height/10.0)
		var elmorigin : Array<CGPoint> = []
		for i in 0..<10 {
			let origin = CGPoint(x: 0.1*CGFloat(i), y:0.1*CGFloat(i))
			elmorigin.append(origin)
		}
		let repetitive = KCRepetitiveImagesLayer(frame: bounds, elementSize: elmsize, elementOrigins: elmorigin, elementDrawer: {
			(context: CGContext, size: CGSize) -> Void in
			Swift.print("Graphics Layer: draw in size:\(size.description) bounds:\(bounds.description)")
			let bounds = CGRect(origin: CGPoint.zero, size: size)
			let vertex = UTVertexDrawer(bounds: bounds, color: KGColorTable.yellow.cgColor)
			vertex.drawContent(context: context)
		})
		drawer.addSublayer(repetitive)
		repetitive.setNeedsDisplay()
	}

	private func setupSymbolViews()
	{
		for symid in 0..<4 {
			let view: KCLayerView
			switch symid {
			case 0:		view = mSymbol0View
			case 1:		view = mSymbol1View
			case 2:		view = mSymbol2View
			default:	view = mSymbol3View
			}

			let bounds     = view.bounds
			let background = KCBackgroundLayer(frame: bounds, color: KGColorTable.black.cgColor)

			view.rootLayer.addSublayer(background)
			let symlayer = UTAllocateSymbol(symbolId: symid, parentBounds: view.bounds)
			background.addSublayer(symlayer)
		}
	}

	private func setupSelectionView()
	{
		let selbounds	= mSelectionView.bounds

		let background = KCBackgroundLayer(frame: selbounds, color: KGColorTable.black.cgColor)
		mSelectionView.rootLayer.addSublayer(background)

		let sellayer	= KCSelectionLayer(frame: selbounds)
		for i in 0...3 {
			let symbol = UTAllocateSymbol(symbolId: i, parentBounds: selbounds)
			sellayer.addSublayer(symbol)
		}
		sellayer.visibleIndex = 0
		background.addSublayer(sellayer)
		mSelectionLayer = sellayer
	}

	public func setupTimer(){
		let timer = KCTimer()
		timer.updateCallback = {
			(time:TimeInterval) -> Bool in
			/*
			if let drawer = self.mStrokeDrawer {
				let center = drawer.bounds.center

				let cosv = CGFloat(cos(Double(time)) * 80.0)
				let sinv = CGFloat(sin(Double(time)) * 80.0)
				let endpt = CGPoint(x: center.x + cosv, y: center.y + sinv)
				drawer.strokes = [CGPoint(x:center.x, y:center.y), endpt]
			}
			*/
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

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}


