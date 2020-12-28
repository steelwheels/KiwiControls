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
	public typealias ExpansionPriorities = KCView.ExpansionPriorities

	var axis: CNAxis = .vertical

	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()
		coreview.accept(visitor: self)

		let prival = ExpansionPriorities(holizontalHugging: 	.low,
						 holizontalCompression: .low,
						 verticalHugging: 	.low,
						 verticalCompression:	.low)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(iconView view: KCIconView){
		let prival = ExpansionPriorities(holizontalHugging: 	.low,
						 holizontalCompression: .low,
						 verticalHugging: 	.low,
						 verticalCompression:	.low)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(button view: KCButton){
		let prival = ExpansionPriorities(holizontalHugging: 	.low,
						 holizontalCompression: .low,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(checkBox view: KCCheckBox){
		let prival = ExpansionPriorities(holizontalHugging: 	.low,
						 holizontalCompression: .low,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(stepper view: KCStepper){
		let prival = ExpansionPriorities(holizontalHugging: 	.low,
						 holizontalCompression: .low,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(textEdit view: KCTextEdit){
		switch view.mode {
		case .label, .value(_, _):
			let prival = ExpansionPriorities(holizontalHugging: 	.middle,
							 holizontalCompression: .fixed,
							 verticalHugging: 	.middle,
							 verticalCompression:	.fixed)
			view.setExpandabilities(priorities: prival)
		case .edit(_), .view(_):
			let prival = ExpansionPriorities(holizontalHugging: 	.middle,
							 holizontalCompression: .fixed,
							 verticalHugging: 	.middle,
							 verticalCompression:	.fixed)
			view.setExpandabilities(priorities: prival)
		}
	}

	open override func visit(consoleView view: KCConsoleView){
		let prival = ExpansionPriorities(holizontalHugging: 	.fixed,
						 holizontalCompression: .fixed,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(terminalView view: KCTerminalView){
		let prival = ExpansionPriorities(holizontalHugging: 	.fixed,
						 holizontalCompression: .fixed,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
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
		let prival = ExpansionPriorities(holizontalHugging: 	.high,
						 holizontalCompression: .high,
						 verticalHugging: 	.high,
						 verticalCompression:	.high)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(labeledStackView view: KCLabeledStackView) {
		let labval = ExpansionPriorities(holizontalHugging: .middle,
						 holizontalCompression: .middle,
						 verticalHugging: .fixed,
						 verticalCompression: .fixed)
		view.labelView.setExpansionPriorities(priorities: labval)
		view.contentsView.accept(visitor: self)
		let stkval = ExpansionPriorities(holizontalHugging: 	.high,
						 holizontalCompression: .high,
						 verticalHugging: 	.high,
						 verticalCompression:	.high)
		view.setExpandabilities(priorities: stkval)
	}

	open override func visit(imageView view: KCImageView){
		let prival = ExpansionPriorities(holizontalHugging: 	.middle,
						 holizontalCompression: .middle,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(navigationBar view: KCNavigationBar){
		let prival = ExpansionPriorities(holizontalHugging: 	.middle,
						 holizontalCompression: .middle,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(colorSelector view: KCColorSelector){
		let prival = ExpansionPriorities(holizontalHugging: 	.low,
						 holizontalCompression: .low,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(popupMenu view: KCPopupMenu){
		let prival = ExpansionPriorities(holizontalHugging: 	.low,
						 holizontalCompression: .low,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(coreView view: KCCoreView){
		NSLog("KCExpansionAdjustor.visit(coreView)")
	}
}


