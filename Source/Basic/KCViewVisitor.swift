/**
 * @file	KCViewVisitor.swift
 * @brief	Define KCViewVisitor class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCViewVisitor: CNLogging
{
	public var console: CNLogConsole?

	public init(console cons: CNLogConsole?){
		console = cons
	}

	open func visit(rootView view: KCRootView){
		visit(coreView: view)
	}

	open func visit(iconView view: KCIconView){
		visit(coreView: view)
	}

	open func visit(button view: KCButton){
		visit(coreView: view)
	}

	open func visit(checkBox view: KCCheckBox){
		visit(coreView: view)
	}

	open func visit(stepper view: KCStepper){
		visit(coreView: view)
	}

	open func visit(textField view: KCTextField){
		visit(coreView: view)
	}

	open func visit(textEdit view: KCTextEdit){
		visit(coreView: view)
	}

	open func visit(tableView view: KCTableView){
		visit(coreView: view)
	}

	open func visit(stackView view: KCStackView){
		visit(coreView: view)
	}

	open func visit(consoleView view: KCConsoleView){
		visit(coreView: view)
	}

	open func visit(imageView view: KCImageView){
		visit(coreView: view)
	}

	open func visit(spriteView view: KCSpriteView){
		visit(coreView: view)
	}

	open func visit(navigationBar view: KCNavigationBar){
		visit(coreView: view)
	}

	open func visit(coreView view: KCCoreView){
	}
}

