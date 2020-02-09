/**
 * @file	KCFrameSizeFinalizer.swift
 * @brief	Define KCFrameSizeFinalizer class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCFrameSizeFinalizer: KCViewVisitor
{
	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()
		coreview.accept(visitor: self)
	}

	open override func visit(stackView view: KCStackView){
		/* First, resize members */
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
	}

	open override func visit(consoleView view: KCConsoleView){
		view.resize(view.frame.size)
	}

	open override func visit(terminalView view: KCTerminalView){
		view.resize(view.frame.size)
	}

	open override func visit(textField view: KCTextField){
		view.resize(view.frame.size)
	}

	open override func visit(textEdit view: KCTextEdit){
		view.resize(view.frame.size)
	}

	open override func visit(spriteView view: KCSpriteView) {
		view.resize(view.frame.size)
	}

	open override func visit(navigationBar view: KCNavigationBar) {
		view.resize(view.frame.size)
	}

	open override func visit(colorSelector view: KCColorSelector) {
		view.resize(view.frame.size)
	}

	open override func visit(coreView view: KCCoreView){
	}
}

