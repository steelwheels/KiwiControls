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
	public typealias ExpansionPriority   = KCViewBase.ExpansionPriority
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
		let targsize = view.intrinsicContentSize
		let cursize  = view.frame.size

		let hhug:  ExpansionPriority
		let hcomp: ExpansionPriority
		if targsize.width > cursize.width {
			hhug  = .high
			hcomp = .fixed
		} else if targsize.width == cursize.width {
			hhug  = .fixed
			hcomp = .fixed
		} else { // newinfo.width < curinfo.width
			hhug  = .fixed
			hcomp = .high
		}

		let vhug:  ExpansionPriority
		let vcomp: ExpansionPriority
		if targsize.height > cursize.height {
			vhug  = .high
			vcomp = .fixed
		} else if targsize.height == cursize.height {
			vhug  = .fixed
			vcomp = .fixed
		} else { // newinfo.height < curinfo.height
			vhug  = .fixed
			vcomp = .high
		}

		let prival = ExpansionPriorities(holizontalHugging: 	hhug,
						 holizontalCompression: hcomp,
						 verticalHugging: 	vhug,
						 verticalCompression:	vcomp)
		CNLog(logLevel: .debug, message: "ExpansionPriorities \(hhug.description()) \(hcomp.description()) \(vhug.description()) \(vcomp.description()) at \(#function)")
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(tableView view: KCTableView){
		let prival = ExpansionPriorities(holizontalHugging: 	.low,
						 holizontalCompression: .fixed,
						 verticalHugging: 	.low,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(stackView view: KCStackView){
		/* Visit children 1st */
		let prevaxis = view.axis
		axis     = prevaxis
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
		/* Calc expansion priority */
		var exppri = ExpansionPriorities(holizontalHugging: .fixed, holizontalCompression: .fixed, verticalHugging: .fixed, verticalCompression: .fixed)
		for subview in view.arrangedSubviews() {
			exppri = ExpansionPriorities.union(exppri, subview.expansionPriority())
		}
		CNLog(logLevel: .debug, message: "Stack: ExpansionPriorities \(exppri.holizontalHugging.description()) \(exppri.holizontalCompression.description()) \(exppri.verticalHugging.description()) \(exppri.verticalCompression.description()) at \(#function)")
		view.setExpandabilities(priorities: exppri)
		/* Keep axis */
		axis = prevaxis
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
						 holizontalCompression: .fixed,
						 verticalHugging: 	.middle,
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

	open override func visit(bitmapView view: KCBitmapView){
		let prival = ExpansionPriorities(holizontalHugging: 	.high,
						 holizontalCompression: .fixed,
						 verticalHugging: 	.high,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(graphics2DView view: KCGraphics2DView){
		let prival = ExpansionPriorities(holizontalHugging: 	.high,
						 holizontalCompression: .fixed,
						 verticalHugging: 	.high,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(coreView view: KCCoreView){
		CNLog(logLevel: .error, message: "KCExpansionAdjustor.visit(coreView)")
	}
}


