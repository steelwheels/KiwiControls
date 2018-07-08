/**
 * @file	KCSize.swift
 * @brief	Extend CGSize class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics
import Foundation

extension KCSize
{	
	public var description: String {
		get {
			let wstr = NSString(format: "%.2lf", self.width)
			let hstr = NSString(format: "%.2lf", self.height)
			return "{width:\(wstr), height:\(hstr)}"
		}
	}
}

public func KCUnionSize(sizeA a: KCSize, sizeB b: KCSize, doVertical vert: Bool) -> KCSize
{
	if vert {
		let width  = max(a.width, b.width)
		let height = a.height + b.height
		return KCSize(width: width, height: height)
	} else {
		let width  = a.width + b.width
		let height = max(a.height, b.height)
		return KCSize(width: width, height: height)
	}
}

