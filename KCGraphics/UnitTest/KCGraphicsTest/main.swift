//
//  main.swift
//  KCGraphicsTest
//
//  Created by Tomoo Hamada on 2016/08/14.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation

print("[KCGraphicsTest]")

let result0 = UTVelocityTest()
let result1 = UTCollisionTest()
let result2 = UTReflectionTest()

let result = result0 && result1 && result2
if result {
	print("[SUMMARY] OK")
	exit(0)
} else {
	print("[SUMMARY] NG")
	exit(1)
}
