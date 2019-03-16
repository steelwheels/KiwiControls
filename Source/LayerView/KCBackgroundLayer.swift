/**
 * @file	KCBackgroundLayer.swift
 * @brief	Define KCBackgroundDrawer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import CoreGraphics
import CoconutData

public class KCBackgroundLayer: KCLayer
{
	public required init(frame f: CGRect, color c: CGColor){
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

