/**
 * @file	KCSceneNode.h
 * @brief	Define KCSceneNode class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import SceneKit
import Canary

public extension SCNNode {
	public func lookAt(target: SCNNode){
		let constraint = SCNLookAtConstraint(target: target)
		constraint.gimbalLockEnabled = true
		if var constraints = self.constraints {
			constraints.append(constraint)
		} else {
			self.constraints = [constraint]
		}
	}

	public func dumpToConsole(console: CNConsole){
		let position = self.position
		console.print(string: "(position: x=\(position.x), y=\(position.y), z=\(position.z))")
		let rotation = self.rotation
		console.print(string: "(rotation: x=\(rotation.x), y=\(rotation.y), z=\(rotation.z), w=\(rotation.w))")
		let orientation = self.orientation
		console.print(string: "(orientation: x=\(orientation.x), y=\(orientation.y), z=\(orientation.z), w=\(orientation.w))")

		if let camera = self.camera {
			console.print(string: "(camera zNear:\(camera.zNear), zFar:\(camera.zFar), xFov:\(camera.xFov), yFov:\(camera.yFov))")
		}
	}
}
