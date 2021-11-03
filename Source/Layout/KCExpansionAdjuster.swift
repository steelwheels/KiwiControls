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

	open override func visit(rootView view: KCRootView){
		let coreview: KCInterfaceView = view.getCoreView()
		coreview.accept(visitor: self)

		let prival = ExpansionPriorities(holizontalHugging: 	.high,
						 holizontalCompression: .high,
						 verticalHugging: 	.high,
						 verticalCompression:	.high)
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
		let prival = ExpansionPriorities(holizontalHugging: 	.middle,
						 holizontalCompression: .fixed,
						 verticalHugging: 	.middle,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(consoleView view: KCConsoleView){
		let prival = ExpansionPriorities(holizontalHugging: 	.fixed,
						 holizontalCompression: .fixed,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(textView view: KCTextView){
		visitTextView(textView: view)
	}

	open override func visit(terminalView view: KCTerminalView){
		visitTextView(textView: view)
	}

	private func visitTextView(textView view: KCView){
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
		CNLog(logLevel: .detail, message: "ExpansionPriorities \(hhug.description()) \(hcomp.description()) \(vhug.description()) \(vcomp.description()) at \(#function)")
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(tableView view: KCTableView){
		/* Set priority value */
		let prival = ExpansionPriorities(holizontalHugging: 	.fixed,
						 holizontalCompression: .fixed,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		/* Visit children 1st */
		let colnum = view.numberOfColumns
		let rownum = view.numberOfRows
		for cidx in 0..<colnum {
			for ridx in 0..<rownum {
				if let child = view.view(atColumn: cidx, row: ridx) {
					child.setExpansionPriorities(priorities: prival)
				}
			}
		}
		/* Visit it self */
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(stackView view: KCStackView){
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
		/* Calc expansion priority */
		var exppri = ExpansionPriorities(holizontalHugging:     .fixed,
						 holizontalCompression: .fixed,
						 verticalHugging:       .fixed,
						 verticalCompression:   .fixed)
		for subview in view.arrangedSubviews() {
			exppri = ExpansionPriorities.union(exppri, subview.expansionPriority())
		}
		CNLog(logLevel: .detail, message: "Stack: ExpansionPriorities \(exppri.holizontalHugging.description()) \(exppri.holizontalCompression.description()) \(exppri.verticalHugging.description()) \(exppri.verticalCompression.description()) at \(#function)")
		view.setExpandabilities(priorities: exppri)
	}

	open override func visit(labeledStackView view: KCLabeledStackView) {
		/* Label */
		let labval = ExpansionPriorities(holizontalHugging: 	.fixed,
						 holizontalCompression: .fixed,
						 verticalHugging: 	.fixed,
						 verticalCompression:	.fixed)
		view.labelView.setExpansionPriorities(priorities: labval)

		/* Contents view */
		visit(stackView: view.contentsView)

		/* Copy same property */
		view.setExpandabilities(priorities: view.contentsView.expansionPriority())
	}

	open override func visit(collectionView view: KCCollectionView){
		let prival = ExpansionPriorities(holizontalHugging: 	.fixed,
						 holizontalCompression: .fixed,
						 verticalHugging: 	.low,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(imageView view: KCImageView){
		let prival = ExpansionPriorities(holizontalHugging: 	.middle,
						 holizontalCompression: .fixed,
						 verticalHugging: 	.middle,
						 verticalCompression:	.fixed)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(iconView view: KCIconView){
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
						 holizontalCompression: .fixed,
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

	open override func visit(bezierView view: KCBezierView) {
		let holiz: ExpansionPriority = view.width  != nil ? .fixed : .high
		let vert:  ExpansionPriority = view.height != nil ? .fixed : .high
		let prival = ExpansionPriorities(holizontalHugging: 	holiz,
						 holizontalCompression: holiz,
						 verticalHugging: 	vert,
						 verticalCompression:	vert)
		view.setExpandabilities(priorities: prival)
	}

	open override func visit(coreView view: KCInterfaceView){
		CNLog(logLevel: .error, message: "KCExpansionAdjustor.visit(coreView) : \(view.description)")
	}
}


