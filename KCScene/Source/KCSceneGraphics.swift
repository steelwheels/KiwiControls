/**
 * @file	KCSceneGraphics.h
 * @brief	Define graphics utility functions
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import SceneKit
import KCGraphics

public func KCPoint3ToVector3(source: KCPoint3) -> SCNVector3 {
	return SCNVector3(x: source.x, y:source.y, z:source.z)
}