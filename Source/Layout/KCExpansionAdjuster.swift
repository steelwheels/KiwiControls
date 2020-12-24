/**
 * @file	KCExpansionAdjuster.swift
 * @brief	Define KCExpansionAdjuster class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCExpansionAdjuster: KCViewVisitor
{
	var axis: CNAxis = .vertical

	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()
		coreview.accept(visitor: self)
		view.setExpandability(holizontal: .low, vertical: .low)
	}

	open override func visit(iconView view: KCIconView){
		view.setExpandability(holizontal: .low, vertical: .low)
	}

	open override func visit(button view: KCButton){
		view.setExpandability(holizontal: .low, vertical: .fixed)
	}

	open override func visit(checkBox view: KCCheckBox){
		view.setExpandability(holizontal: .low, vertical: .fixed)
	}

	open override func visit(stepper view: KCStepper){
		view.setExpandability(holizontal: .low, vertical: .fixed)
	}

	open override func visit(textEdit view: KCTextEdit){
		switch view.mode {
		case .label, .value(_, _):
			view.setExpandability(holizontal: .fixed, vertical: .fixed)
		case .edit(_), .view(_):
			view.setExpandability(holizontal: .fixed, vertical: .middle)
		}
	}

	open override func visit(consoleView view: KCConsoleView){
		view.setExpandability(holizontal: .fixed, vertical: .fixed)
	}

	open override func visit(terminalView view: KCTerminalView){
		view.setExpandability(holizontal: .fixed, vertical: .fixed)
	}

	open override func visit(tableView view: KCTableView){
		visit(coreView: view)
	}

	open override func visit(stackView view: KCStackView){
		/* Visit children 1st */
		let prevaxis = view.axis
		axis     = prevaxis
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
		/* Restrore axis */
		axis = prevaxis
		view.setExpandability(holizontal: .high, vertical: .high)
	}

	open override func visit(labeledStackView view: KCLabeledStackView) {
		view.labelView.setExpansionPriority(holizontal: .middle, vertical: .fixed)
		view.contentsView.accept(visitor: self)
		view.setExpandability(holizontal: .high, vertical: .high)
	}

	open override func visit(imageView view: KCImageView){
		view.setExpandability(holizontal: .fixed, vertical: .fixed)
	}

	open override func visit(navigationBar view: KCNavigationBar){
		view.setExpandability(holizontal: .middle, vertical: .fixed)
	}

	open override func visit(colorSelector view: KCColorSelector){
		view.setExpandability(holizontal: .low, vertical: .fixed)
	}

	open override func visit(popupMenu view: KCPopupMenu){
		view.setExpandability(holizontal: .low, vertical: .fixed)
	}

	open override func visit(coreView view: KCCoreView){
		switch axis {
		case .horizontal:
			view.setExpandability(holizontal: .low, vertical: .middle)
		case .vertical:
			view.setExpandability(holizontal: .middle, vertical: .low)
		@unknown default:
			NSLog("Unknown axis type")
		}
	}
}


