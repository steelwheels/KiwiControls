//
//  UTVelocity.swift
//  KCGraphics
//
//  Created by Tomoo Hamada on 2016/06/12.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

public func UTVelocityTest() -> Bool {
	let v00 = CNVelocity(x: 10.0, y: 10.0)
	print("v00 = \(v00.longDescription)")

	let v01 = CNVelocity(x: 10.0, y:-10.0)
	print("v01 = \(v01.longDescription)")

	let v02 = CNVelocity(x:  0.0, y:10.0)
	print("v02 = \(v02.longDescription)")

	let v03 = CNVelocity(x: 10.0, y: 0.0)
	print("v03 = \(v03.longDescription)")

	let PI = CGFloat(M_PI)

	let v10 = CNVelocity(v: 10.0, angle: 0.0 * PI)
	print("v10 = \(v10.longDescription)")

	let v11 = CNVelocity(v: 10.0, angle: 0.25 * PI)
	print("v11 = \(v11.longDescription)")

	let v12 = CNVelocity(v: 10.0, angle: 0.5 * PI)
	print("v12 = \(v12.longDescription)")

	let v13 = CNVelocity(v: 10.0, angle: 1.5 * PI)
	print("v13 = \(v13.longDescription)")

	return true
}

