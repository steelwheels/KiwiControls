/**
 * @file	KCPoint3.h
 * @brief	Define KCPoint3 class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import SceneKit

public struct KCPoint3 {
	public var x : CGFloat ;
	public var y : CGFloat ;
	public var z : CGFloat ;
	
	public init(x: CGFloat, y: CGFloat, z: CGFloat){
		self.x = x
		self.y = y
		self.z = z
	}
}

func - (s0: KCPoint3, s1: KCPoint3) -> SCNVector3 {
	let dx = s0.x - s1.x
	let dy = s0.y - s1.y
	let dz = s0.z - s1.z
	return SCNVector3(x:dx, y:dy, z:dz)
}