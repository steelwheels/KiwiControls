/**
 * @file	KCSceneNode.h
 * @brief	Define KCSceneNode class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import SceneKit
import Canary

public extension SCNNode {
	public var color: NSColor? {
		get {
			if let geometry = self.geometry {
				for material in geometry.materials {
					if let color = material.diffuse.contents as? NSColor {
						return color
					}
				}
			}
			return nil
		}
		set(newcolor) {
			if let geometry = self.geometry {
				let materials = geometry.materials
				if materials.count > 0 {
					for materials in geometry.materials {
						if let _ = materials.diffuse.contents as? NSColor {
							materials.diffuse.contents = newcolor
							return
						}
					}
				}
				let newmaterial = SCNMaterial()
				newmaterial.diffuse.contents = newcolor
				geometry.materials.append(newmaterial)
			}
		}
	}

	public func lookAt(target targ: SCNNode){
		let constraint = SCNLookAtConstraint(target: targ)
		constraint.gimbalLockEnabled = true
		if var constraints = self.constraints {
			constraints.append(constraint)
		} else {
			self.constraints = [constraint]
		}
	}

	public func dump(console cons: CNConsole){
		let position = self.position
		cons.print(string: "(position: x=\(position.x), y=\(position.y), z=\(position.z))")
		let rotation = self.rotation
		cons.print(string: "(rotation: x=\(rotation.x), y=\(rotation.y), z=\(rotation.z), w=\(rotation.w))")
		let orientation = self.orientation
		cons.print(string: "(orientation: x=\(orientation.x), y=\(orientation.y), z=\(orientation.z), w=\(orientation.w))")

		if let camera = self.camera {
			cons.print(string: "(camera zNear:\(camera.zNear), zFar:\(camera.zFar), xFov:\(camera.xFov), yFov:\(camera.yFov))")
		}
	}
}
