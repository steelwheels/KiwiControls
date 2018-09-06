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

		/* Push screen size */
		let winsize = KCLayouter.windowSize(viewController: vcont)
		mCurrentFrames.push(KCRect(origin: KCPoint.zero, size: winsize))
	}

	public func layout(rootView view: KCRootView){
		view.accept(visitor: self)
	}

	open override func visit(rootView view: KCRootView){
		if let frame = mCurrentFrames.peek() {
			/* Setup root view */
			view.frame     = frame
			view.bounds    = frame
			view.fixedSize = frame.size
			view.setFixedSizeForLayout(size: frame.size)
			view.translatesAutoresizingMaskIntoConstraints = true

			/* Setup content view */
			if let core: KCView = view.getCoreView() {
				let cinset = KCLayouter.safeAreaInset(viewController: mViewController)
				view.allocateSubviewLayout(subView: core, in: cinset)

				let cframe = KCEdgeInsetsInsetRect(frame, cinset)
				mCurrentFrames.push(cframe)
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

	private class func windowSize(viewController vcont: KCViewController) -> KCSize {
		let result: KCSize
		#if os(OSX)
			if let window = vcont.view.window {
				result = window.entireFrame.size
			} else {
				NSLog("\(#function) [Error] No window")
				result = KCSize(width: 100.0, height: 100.0)
			}
		#else
			result = UIScreen.main.bounds.size
		#endif
		return result
	}

	private class func safeAreaInset(viewController vcont: KCViewController) -> KCEdgeInsets {
		if let singlecont = vcont as? KCSingleViewController {
			if let parentcont = singlecont.parentController {
				return KCLayouter.safeAreaInset(viewController: parentcont)
			}
		}
		let space = KCPreference.shared.layoutPreference.spacing
		#if os(OSX)
			let result = KCEdgeInsets(top: space, left: space, bottom: space, right: space)
		#else
			let topmargin: CGFloat
			if KCPreference.shared.layoutPreference.isPortrait {
				topmargin =  16.0 - space
			} else {
				topmargin =  0.0
			}
			let insets = vcont.view.safeAreaInsets
			let result = KCEdgeInsets(top:    insets.top    + topmargin + space,
						  left:   insets.left   + space,
						  bottom: insets.bottom + space,
						  right:  insets.right  + space)
		#endif
		return result
	}
}

