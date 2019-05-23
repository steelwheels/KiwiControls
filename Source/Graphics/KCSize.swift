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

	func inset(by inset: KCEdgeInsets) -> KCSize {
		let width  = max(0.0, self.width  - (inset.left + inset.right))
		let height = max(0.0, self.height - (inset.top  + inset.bottom))
		return KCSize(width: width, height: height)
	}
}

public func KCUnionSize(sizeA a: KCSize, sizeB b: KCSize) -> KCSize
{
	let width  = max(a.width,  b.width)
	let height = max(a.height, b.height)
	return KCSize(width: width, height: height)
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

public func KCSectSize(sizeA a: KCSize, sizeB b: KCSize) -> KCSize
{
	let width  = min(a.width,  b.width)
	let height = min(a.height, b.height)
	return KCSize(width: width, height: height)
}

