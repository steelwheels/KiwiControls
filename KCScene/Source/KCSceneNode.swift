/**
 * @file	KCSceneNode.h
 * @brief	Define KCSceneNode class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import SceneKit
import Canary

public extension SCNNode {
	public func dumpToConsole(console: CNConsole){
		let angles = self.eulerAngles
		console.print(string: "(x:\(angles.x), y:\(angles.y), z:\(angles.z))")
	}
}
