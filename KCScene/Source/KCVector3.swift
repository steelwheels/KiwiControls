/**
 * @file	KCVector3.h
 * @brief	Define KCVector3 class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 * @par Reference
 *   https://github.com/kingreza/Swift-Boids/blob/master/SchoolOfShips/SCNVector3Extensions.swift%20.swift
 */

import SceneKit

extension SCNVector3
{
	func length() -> CGFloat {
		return sqrt(x*x + y*y + z*z)
	}

	func normalize() -> SCNVector3 {
		let len = length()
		if len > 0.0 {
			return SCNVector3(x/len, y/len, z/len)
		} else {
			return SCNVector3(0.0, 0.0, 0.0)
		}
	}

	/**
	 * Calculates the dot product between two SCNVector3.
	 */
	func dot(vector: SCNVector3) -> CGFloat {
		return (x * vector.x) + (y * vector.y) + (z * vector.z)
	}

	/**
	 * Calculates the cross product between two SCNVector3.
	 */
	func cross(vector: SCNVector3) -> SCNVector3 {
		return SCNVector3Make( ((y * vector.z) - (z * vector.y)),
		                       ((z * vector.x) - (x * vector.z)),
		                       ((x * vector.y) - (y * vector.x)))
	}
}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
	return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
	return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}


