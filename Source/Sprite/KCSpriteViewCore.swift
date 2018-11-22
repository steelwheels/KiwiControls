/**
 * @file KCSpriteViewCore.swift
 * @brief Define KCSpriteViewCore class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import SpriteKit
import Foundation

open class KCSpriteViewCore: KCView
{
	#if os(OSX)
	@IBOutlet weak var mSpriteView: SKView!
	#else
	@IBOutlet weak var mSpriteView: SKView!
	#endif

	private var mScene :	SKScene? = nil

	public func setup(frame frm: CGRect) {
		let scene = SKScene(size: frm.size)
		scene.scaleMode = .resizeFill

		mScene = scene
		mSpriteView.presentScene(mScene)
	}

	private var scene: SKScene {
		get {
			if let scene = mScene {
				return scene
			} else {
				fatalError("No object: \(#function)")
			}
		}
	}

	public var backgroundColor: KCColor {
		get 		{ return scene.backgroundColor }
		set(color) 	{ scene.backgroundColor = color }
	}
}

