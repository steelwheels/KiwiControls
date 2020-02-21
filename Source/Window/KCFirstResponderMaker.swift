/**
 * @file	KCFirstResponderMaker.swift
 * @brief	Define KCFirstResponderMaker class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCFirstResponderMaker: KCViewVisitor
{
	private var mResult:		Bool
	#if os(OSX)
		private var mParentWindow:	NSWindow?
	#endif

	public override init(console cons: CNConsole) {
		mResult		= false
		#if os(OSX)
			mParentWindow	= nil
		#endif
		super.init(console: cons)
	}

	public func makeFirstResponder(rootView root: KCRootView) -> Bool {
		mResult		= false
		#if os(OSX)
			mParentWindow = nil
			if let window = root.window {
				mParentWindow = window
				root.accept(visitor: self)
			}
		#else
			root.accept(visitor: self)
		#endif
		return mResult
	}

	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()
		coreview.accept(visitor: self)
	}

	open override func visit(stackView view: KCStackView){
		if !mResult {
			for subview in view.arrangedSubviews() {
				subview.accept(visitor: self)
				if mResult {
					break
				}
			}
		}
	}

	open override func visit(labeledStackView view: KCLabeledStackView){
		view.contentsView.accept(visitor: self)
	}

	open override func visit(terminalView view: KCTerminalView) {
		if !mResult {
			#if os(OSX)
				mResult = view.becomeFirstResponder(for: mParentWindow!)
			#else
				mResult = view.becomeFirstResponder()
			#endif
		}
	}

	open override func visit(coreView view: KCCoreView){
	}
}

