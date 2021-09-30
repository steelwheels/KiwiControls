/**
 * @file	KCViewVisitor.swift
 * @brief	Define KCViewVisitor class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCViewVisitor
{
	public init(){
	}

	open func visit(rootView view: KCRootView){
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

	open func visit(textEdit view: KCTextEdit){
		visit(coreView: view)
	}

	open func visit(tableView view: KCTableView){
		visit(coreView: view)
	}

	open func visit(stackView view: KCStackView){
		visit(coreView: view)
	}

	open func visit(labeledStackView view: KCLabeledStackView) {
		visit(coreView: view)
	}

	open func visit(consoleView view: KCConsoleView){
		visit(coreView: view)
	}

	open func visit(terminalView view: KCTerminalView){
		visit(coreView: view)
	}

	open func visit(textView view: KCTextView){
		visit(coreView: view)
	}

	open func visit(iconView view: KCIconView){
		visit(coreView: view)
	}

	open func visit(imageView view: KCImageView){
		visit(coreView: view)
	}

	open func visit(navigationBar view: KCNavigationBar){
		visit(coreView: view)
	}

	open func visit(colorSelector view: KCColorSelector){
		visit(coreView: view)
	}

	open func visit(popupMenu view: KCPopupMenu){
		visit(coreView: view)
	}

	open func visit(graphics2DView view: KCGraphics2DView){
	}

	open func visit(bitmapView view: KCBitmapView){
	}

	open func visit(coreView view: KCInterfaceView){
	}
}

