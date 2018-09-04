/**
 * @file	KCLayouter.swift
 * @brief	Define KCLayouter class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLayouter: KCViewVisitor
{
	private var mViewController:	KCSingleViewController
	private var mCurrentFrames:	CNStack<KCRect>
	private var mConsole:		CNConsole

	public init(viewController vcont: KCSingleViewController, console cons: CNConsole){
		mViewController	= vcont
		mCurrentFrames  = CNStack<KCRect>()
		mConsole	= cons

		/* Setup entire frame */
		let entiresize  = mViewController.entireFrame.size
		let entireframe = KCRect(origin: KCPoint.zero, size: entiresize)
		mCurrentFrames.push(entireframe)
		if let entireview = vcont.entireView, let rootview = vcont.rootView {
			entireview.frame  = entireframe
			entireview.bounds = entireframe
			entireview.setFixedSizeForLayout(size: entireframe.size)

			entireview.allocateSubviewLayout(subView: rootview)
		} else {
			fatalError("No entire frame")
		}
	}

	public func layout(rootView view: KCRootView){
		view.accept(visitor: self)
	}

	open override func visit(rootView view: KCRootView){
		if let frame = mCurrentFrames.peek() {
			view.frame     = frame
			view.bounds    = KCRect(origin: KCPoint.zero, size: frame.size)
			/* Fix the root to the window size (OSX) */
			view.fixedSize = frame.size
			/* Visit sub view */
			if let core: KCView = view.getCoreView() {
				let cinset  = mViewController.safeAreaInset
				let cbounds = KCEdgeInsetsInsetRect(view.bounds, cinset)
				view.allocateSubviewLayout(subView: core, in: cinset)

				mCurrentFrames.push(cbounds)
				core.accept(visitor: self)
				let _ = mCurrentFrames.pop()
			}
		} else {
			fatalError("\(#function): Can not happen")
		}
	}

	open override func visit(iconView view: KCIconView){
		self.visit(coreView: view)
	}

	open override func visit(button view: KCButton){
		self.visit(coreView: view)
	}

	open override func visit(checkBox view: KCCheckBox){
		self.visit(coreView: view)
	}

	open override func visit(stepper view: KCStepper){
		self.visit(coreView: view)
	}

	open override func visit(textField view: KCTextField){
		self.visit(coreView: view)
	}

	open override func visit(textEdit view: KCTextEdit){
		self.visit(coreView: view)
	}

	open override func visit(tableView view: KCTableView){
		self.visit(coreView: view)
	}

	open override func visit(stackView view: KCStackView){
		self.visit(coreView: view)

		if let frame = mCurrentFrames.peek() {
			/* Decide size of children */
			var cframe: KCRect
			switch view.alignment {
			case .horizontal(_):
				let newx      = KCView.noIntrinsicMetric
				let newy      = frame.origin.y
				let newwidth  = KCView.noIntrinsicMetric
				let newheight = frame.size.height
				cframe = KCRect(x: newx, y: newy, width: newwidth, height: newheight)
			case .vertical(_):
				let newx      = frame.origin.x
				let newy      = KCView.noIntrinsicMetric
				let newwidth  = frame.size.width
				let newheight = KCView.noIntrinsicMetric
				cframe = KCRect(x: newx, y: newy, width: newwidth, height: newheight)
			}
			/* Visit subviews */
			mCurrentFrames.push(cframe)
			for subview in view.arrangedSubviews() {
				subview.accept(visitor: self)
			}
			let _ = mCurrentFrames.pop()
		}
	}

	open override func visit(consoleView view: KCConsoleView){
		self.visit(coreView: view)
	}

	open override func visit(imageView view: KCImageView){
		self.visit(coreView: view)
	}

	open override func visit(coreView view: KCCoreView){
		if let frame = mCurrentFrames.peek() {
			view.fixedSize   = frame.size

			let width = frame.size.width
			if width > 0.0 {
				view.frame.size.width   = width
				view.bounds.size.width  = width
			}

			let height = frame.size.height
			if height > 0.0 {
				view.frame.size.height  = height
				view.bounds.size.height = height
			}
		}
	}
}

