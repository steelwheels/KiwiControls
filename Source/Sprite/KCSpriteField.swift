/**
 * @file KCSpriteField.swift
 * @brief Define KCSpriteField class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import SpriteKit
import Foundation

public class KCSpriteField
{
	public weak var parentScene:	SKScene?

	public init(){
		parentScene = nil
	}

	private var parent: SKScene {
		get {
			if let parent = parentScene {
				return parent
			} else {
				fatalError("No parent scene")
			}
		}
	}

	public var logicalSize: CGSize {
		get {
			let psize = physicalSize
			let lsize: CGSize
			if psize.width >= psize.height && psize.height > 0 {
				lsize = CGSize(width: psize.width / psize.height, height: 1.0)
			} else if psize.height > psize.width && psize.width > 0 {
				lsize = CGSize(width: 1.0, height: psize.height / psize.width)
			} else {
				lsize = CGSize(width: 1.0, height: 1.0)
			}
			return lsize
		}
	}

	public var physicalSize: CGSize {
		get { return parent.size }
	}

	public func toValue() -> CNNativeValue {
		var top: Dictionary<String, CNNativeValue> = [:]
		top["size"] = CNNativeValue.sizeValue(logicalSize)
		return CNNativeValue.dictionaryValue(top)
	}

	public func logicalToPhysical(size sz: CGSize) -> CGSize {
		let pframe = parent.frame
		let lsize  = logicalSize
		let width  = sz.width  * pframe.width  / lsize.width
		let height = sz.height * pframe.height / lsize.height
		return CGSize(width: width, height: height)
	}

	public func logicalToPhysical(point pt: CGPoint) -> CGPoint {
		let pframe = parent.frame
		let lsize  = logicalSize
		let x = pt.x * pframe.width  / lsize.width
		let y = pt.y * pframe.height / lsize.height
		return CGPoint(x: x, y: y)
	}

	public func logicalToPhysical(xSpeed spd: CGFloat) -> CGFloat {
		let pframe = parent.frame
		let newspd = spd * pframe.width / logicalSize.width
		return newspd
	}

	public func logicalToPhysical(ySpeed spd: CGFloat) -> CGFloat {
		let pframe = parent.frame
		let newspd = spd * pframe.height / logicalSize.height
		return newspd
	}

	public func physicalToLogical(size sz: CGSize) -> CGSize {
		let pframe = parent.frame
		let lsize  = logicalSize
		let width  = sz.width  * lsize.width  / pframe.width
		let height = sz.height * lsize.height / pframe.height
		return CGSize(width: width, height: height)
	}

	public func physicalToLogical(point pt: CGPoint) -> CGPoint {
		let pframe = parent.frame
		let lsize  = logicalSize
		let x = pt.x * lsize.width  / pframe.width
		let y = pt.y * lsize.height / pframe.height
		return CGPoint(x: x, y: y)
	}

	public func physicalToLogical(xSpeed speed: CGFloat) -> CGFloat {
		let pframe   = parent.frame
		return speed * logicalSize.width / pframe.width
	}

	public func physicalToLogical(ySpeed speed: CGFloat) -> CGFloat {
		let pframe   = parent.frame
		return speed * logicalSize.height / pframe.height
	}
}
