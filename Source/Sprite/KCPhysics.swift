/**
 * @file KCPhysics.swift
 * @brief Extend pysics class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 * @par Reference
 *  - https://hawksnowlog.blogspot.com/2017/11/infinite-ball-with-spritekit.html
 */

import SpriteKit
import Foundation

extension SKPhysicsBody {
	public enum BodyType: UInt32 {
		case Boundary		= 0
		case Object		= 1
		public var mask: UInt32 {
			get { return 0x1 << self.rawValue }
		}
	}

	public var bodyType: BodyType {
		get {
			let result: BodyType
			switch self.categoryBitMask {
			case BodyType.Boundary.mask:	result = .Boundary
			case BodyType.Object.mask:	result = .Object
			default:
				NSLog("Unknown body type")
				result = .Object
			}
			return result
		}
	}

	public func setup(bodyType type: BodyType){
		switch type {
		case .Boundary:
			self.categoryBitMask    = BodyType.Boundary.mask
			self.isDynamic		= false
			self.friction		= 0
			//self.mass		= 100.0
		case .Object:
			self.categoryBitMask    = BodyType.Object.mask
			self.isDynamic		= true
			self.friction		= 1
			//self.mass		= 1.0
		}
		self.affectedByGravity	= false
		self.allowsRotation	= false
		self.linearDamping	= 0.0
		self.angularDamping	= 0.0
		self.restitution	= 1
		self.collisionBitMask   = BodyType.Boundary.mask | BodyType.Object.mask
		self.contactTestBitMask = BodyType.Boundary.mask | BodyType.Object.mask
	}
}

extension SKPhysicsWorld {
	public func setup(delegate dlg: SKPhysicsContactDelegate){
		self.gravity = CGVector(dx: 0.0, dy: 0.0)
		self.contactDelegate = dlg
	}
}

