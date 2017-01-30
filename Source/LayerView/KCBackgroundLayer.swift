/**
 * @file	KCBackgroundLayer.swift
 * @brief	Define KCBackgroundDrawer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiGraphics
import CoreGraphics

public class KCBackgroundLayer: KCLayer
{
	public init(frame f: CGRect, color c: CGColor){
		super.init(frame: f)
		self.backgroundColor = c
		#if os(OSX)
			self.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
		#endif
	}
	
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}



