/**
 * @file	KCGroupMaker.swift
 * @brief	Define KCGroupMaker class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Foundation

public class KCGroupMaker
{
	public class func makeGroups(stackView view: KCStackView) -> Array<Array<KCView>> {
		var result: Array<Array<KCView>> = []

		let contents = view.arrangedSubviews()
		if contents.count >= 2 {
			var srcs: Array<KCView> = contents
			while srcs.count > 0 {
				let src     			= srcs[0]
				let rests   			= srcs.dropFirst()
				var unusedsrcs: Array<KCView> 	= []
				var usedsrcs: Array<KCView> 	= [src]
				for rest in rests {
					if isSameComponent(componentA: src, componentB: rest) {
						usedsrcs.append(rest)
					} else {
						unusedsrcs.append(rest)
					}
				}
				if usedsrcs.count > 1 {
					result.append(usedsrcs)
				}
				srcs = unusedsrcs
			}
		}

		return result
	}

	public class func isSameComponent(componentA compa: KCView, componentB compb: KCView) -> Bool {
		var result: Bool = false
		if let stacka = compa as? KCStackView, let stackb = compb as? KCStackView {
			let childrena = stacka.arrangedSubviews()
			let childrenb = stackb.arrangedSubviews()
			if childrena.count == childrenb.count {
				var issame = true
				for i in 0..<childrena.count {
					if !isSameComponent(componentA: childrena[i], componentB: childrenb[i]) {
						issame = false
						break
					}
				}
				result = issame
			}
		} else {
			result = (type(of: compa) == type(of: compb))
		}
		return result
	}
}
