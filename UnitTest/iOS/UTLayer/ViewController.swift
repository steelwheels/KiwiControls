//
//  ViewController.swift
//  UTLayer
//
//  Created by Tomoo Hamada on 2016/11/23.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiGraphics
import KiwiControls

class ViewController: UIViewController
{
	@IBOutlet weak var mImageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
        
		// Do any additional setup after loading the view, typically from a nib.
		let bounds = mImageView.bounds
		let image = UIImage.generate(size: bounds.size, drawFunc: {
			(size: CGSize, context: CGContext) -> Void in
			drawVertex(size: size, context: context)
		})
		mImageView.image = image

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.

		}

	private func drawVertex(size sz: CGSize, context ctxt: CGContext) -> Void {
		let bounds = CGRect(origin: CGPoint.zero, size: sz)
		let center = bounds.center
		let radius = min(sz.width, sz.height)/2.0
		let eclipse  = KGEclipse(center: center, innerRadius: radius*0.5, outerRadius: radius)
		let gradient = KGGradientTable.sharedGradientTable.Gradient(forColor: KGColorTable.black.cgColor)

		ctxt.draw(eclipse: eclipse, withGradient: gradient)
	}
}

/*
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


*/
