/**
 * @file	KCBackgroundDrawer.swift
 * @brief	Define KCBackgroundDrawer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiGraphics
import CoreGraphics

public class KCBackgroundLayer: KCLayer
{
	public override init(frame frm: CGRect){
		super.init(frame: frm)
		self.backgroundColor = CGColor.white
	}

	public required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var color: CGColor {
		get {
			if let color = self.backgroundColor {
				return color
			} else {
				fatalError("No background color")
			}
		}
		set(newcolor) { self.backgroundColor = newcolor }
	}

	public override func layerDescription() -> String {
		let superdesc = super.layerDescription()

		var colname: String
		if let components = color.components {
			colname = "[\(components)]"
		} else {
			colname = "No color"
		}
		return "(background-layer color:\(colname) super:\(superdesc))"
	}
}

