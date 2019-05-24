/**
 * @file	KCIntrinsicSizeAllocator.swift
 * @brief	Define KCIntrinsicSizeAllocator class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCIntrisicSizeAllocator: KCViewVisitor
{
	open override func visit(rootView view: KCRootView){
		if let core: KCView = view.getCoreView() {
			core.accept(visitor: self)
		}
	}

	open override func visit(stackView view: KCStackView){
		for subview in view.arrangedSubviews() {
			if let view = subview as? KCCoreView {
				view.accept(visitor: self)
			} else {
				log(type: .Error, string: "Unexpected view", file: #file, line: #line, function: #function)
			}
		}
	}

	open override func visit(coreView view: KCCoreView){
		view.resize(view.frame.size)
	}
}

