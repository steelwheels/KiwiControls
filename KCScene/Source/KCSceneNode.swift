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
		let curpos = self.position.normalize()
		let dot   = curpos.dot(target)
		let rotangle = GLKMathDegreesToRadians(acos(Float(dot)))
		let rotaxis  = curpos.cross(target).normalize()
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
	}
}
