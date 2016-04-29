/**
 * @file	KCSceneNode.h
 * @brief	Define KCSceneNode class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import SceneKit
import Canary

public extension SCNNode {
	public func lookAt(target: SCNVector3){
		let srcpos   = self.position.normalize()
		let dstpos   = (target - self.position).normalize()
		let dot      = srcpos.dot(dstpos)
		let rotangle = GLKMathDegreesToRadians(acos(Float(dot)))
		let rotaxis  = srcpos.cross(dstpos).normalize()
		let q = GLKQuaternionMakeWithAngleAndAxis(Float(rotangle), Float(rotaxis.x), Float(rotaxis.y), Float(rotaxis.z))
		self.rotation = SCNVector4(x: CGFloat(q.x), y: CGFloat(q.y), z: CGFloat(q.z), w: CGFloat(q.w))
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
