/**
 * @file	KCConstraintAllocator.swift
 * @brief	Define KCConstraintAllocator class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Foundation

public class KCConstraintAllocator: KCViewVisitor
{
	open override func visit(rootView view: KCRootView){
		visit(coreView: view)
	}

	open override func visit(iconView view: KCIconView){
		visit(coreView: view)
	}

	open override func visit(button view: KCButton){
		visit(coreView: view)
	}

	open override func visit(checkBox view: KCCheckBox){
		visit(coreView: view)
	}

	open override func visit(stepper view: KCStepper){
		visit(coreView: view)
	}

	open override func visit(textField view: KCTextField){
		visit(coreView: view)
	}

	open override func visit(textEdit view: KCTextEdit){
		visit(coreView: view)
	}

	open override func visit(tableView view: KCTableView){
		visit(coreView: view)
	}

	open override func visit(stackView view: KCStackView){
		visit(coreView: view)
	}

	open override func visit(consoleView view: KCConsoleView){
		visit(coreView: view)
	}

	open override func visit(imageView view: KCImageView){
		visit(coreView: view)
	}

	open override func visit(spriteView view: KCSpriteView){
		visit(coreView: view)
	}

	open override func visit(coreView view: KCCoreView){
	}
}

