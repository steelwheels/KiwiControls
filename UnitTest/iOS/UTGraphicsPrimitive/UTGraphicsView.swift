//
//  UTGraphicsView.swift
//  KiwiControls
//
//  Created by Tomoo Hamada on 2016/12/08.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import KiwiGraphics

public class UTGraphicsView: KCView
{
	private var mHexagon0	: KGHexagon?	= nil

	public func setup(bounds bnds: CGRect){
		let origin0 = bnds.origin + CGPoint(x: 10.0, y:1.0)
		let size0   = CGSize(width: 20.0, height: 20.0)
		let bounds0 = CGRect(origin: origin0, size: size0)
		mHexagon0 = KGHexagon(center: bounds0.center, radius: size0.width)
	}
	
	public override func draw(_ dirtyRect: CGRect) {
		let context = super.currentContext
		if let hex0 = mHexagon0 {
			if hex0.bounds.intersects(dirtyRect) {
				drawHexagon(hexagon: hex0)
			}
		}
	}
}

