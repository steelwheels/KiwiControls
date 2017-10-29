/**
 * @file	KCViewTraverser.swift
 * @brief	Define KCViewTraverser class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public func KCTraverseView(rootView view: KCViewBase, traverseFunc tfunc: ((_ view: KCViewBase, _ level:Int) -> Bool))
{
	let _ = traverseView(rootView: view, level: 0, traverseFunc: tfunc)
}

private func traverseView(rootView view: KCViewBase, level lvl: Int, traverseFunc tfunc: ((_ view: KCViewBase, _ level:Int) -> Bool)) -> Bool
{
	/* traverse callback, when it returns false, stop traverse */
	if tfunc(view, lvl) {
		let nextlvl = lvl + 1
		for subview in view.subviews {
			if !traverseView(rootView: subview, level: nextlvl, traverseFunc: tfunc) {
				return false
			}
		}
		return true
	} else {
		return false
	}
}
