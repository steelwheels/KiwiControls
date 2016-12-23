/**
 * @file	KCButton.swift
 * @brief	Define KCButton class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
	public typealias KCButtonBase = UIButton
#else
	import Cocoa
	public typealias KCButtonBase = NSButton
#endif
import Canary

open class KCButton: KCButtonBase
{
	private dynamic var mState: CNState?   = nil

	deinit {
		KCDeinitObserver(state: mState, observer: self)
	}

	public var controllerState : CNState? {
		get {
			return mState
		}
		set(newstate) {
			mState = KCReplaceState(originalState: mState, newState: newstate, observer: self)
		}
	}

	final public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if let state = KCDidStateUpdated(forKeyPath: keyPath, of: object) {
			if let doenable = updateEnable(state: state) {
				self.isEnabled = doenable
			}
			if let title = updateTitle(state: state) {
				#if os(iOS)
				self.setTitle(title, for: .normal)
				#else
				self.title = title
				#endif
			}
		}
	}

	open func updateEnable(state: CNState) -> Bool? {
		return nil
	}

	open func updateTitle(state: CNState) -> String? {
		return nil
	}
}
