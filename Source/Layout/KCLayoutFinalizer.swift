/*
 * @file  KCLayoutFinaluzer.swift
 * @brief Define KCLayoutFinalizer class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLayoutFinalizer
{
	public init(){
	}

	public func layout(rootView view: KCRootView){
		let adjuster = KCContentSizeAdjuster()
		view.accept(visitor: adjuster)
	}
}

