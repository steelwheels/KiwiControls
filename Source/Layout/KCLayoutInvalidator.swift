/**
 * @file	KCLayoutInvalidator.swift
 * @brief	Define KCLayoutInvalidator class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLayoutInvalidator: KCViewVisitor
{
	private var mTargetView: 	KCView
	private var mVisitResult:	Bool


	public init(target view: KCView){
		mTargetView  = view
		mVisitResult = false
	}

	private func doInvalidate(view v: KCView, doInvalidate doinv: Bool){
		if doinv {
			v.invalidateIntrinsicContentSize()
			v.requireLayout()
		}
	}

	private func checkTarget(view v: KCView) -> Bool {
		var result: Bool = false
		if v == mTargetView {
			result = true
		} else if let iv = v as? KCInterfaceView {
			if let cv: KCView = iv.getCoreView() {
				if cv == mTargetView {
					result = true
				}
			}
		}
		return result
	}

	public override func visit(rootView view: KCRootView){
		let doinv0: Bool
		if let core: KCView = view.getCoreView() {
			core.accept(visitor: self)
			doinv0 = mVisitResult
		} else {
			doinv0 = false
		}
		let doinv1 = doinv0 || checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv1)
		mVisitResult = doinv1
	}

	public override func visit(button view: KCButton){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(checkBox view: KCCheckBox){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(stepper view: KCStepper){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(textEdit view: KCTextEdit){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(tableView view: KCTableView){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(stackView view: KCStackView){
		var doinv: Bool = false
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
			if mVisitResult {
				doinv = true
			}
		}
		doinv = doinv || checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(labeledStackView view: KCLabeledStackView) {
		view.contentsView.accept(visitor: self)
		let doinv1 = mVisitResult
		let doinv2 = (view.labelView == mTargetView)
		let doinv3 = checkTarget(view: view)
		let doinv  = doinv1 || doinv2 || doinv3
		if doinv {
			view.labelView.invalidateIntrinsicContentSize()
		}
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(consoleView view: KCConsoleView){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(terminalView view: KCTerminalView){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(textView view: KCTextView){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(iconView view: KCIconView){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(imageView view: KCImageView){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(navigationBar view: KCNavigationBar){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(colorSelector view: KCColorSelector){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(popupMenu view: KCPopupMenu){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(graphics2DView view: KCGraphics2DView){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(bezierView view: KCBezierView){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(bitmapView view: KCBitmapView){
		let doinv = checkTarget(view: view)
		doInvalidate(view: view, doInvalidate: doinv)
		mVisitResult = doinv
	}

	public override func visit(coreView view: KCInterfaceView){
		/* Do nothing */
	}
}

