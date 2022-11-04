/**
 * @file	KCLayoutChecker.swift
 * @brief	Define KCLayoutChecker class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData

public class KCLayoutChecker : KCViewVisitor
{
	private var mLimitSize: CGSize = CGSize.zero
	#if os(OSX)
		private let mLogLevel:  CNConfig.LogLevel	= .warning
	#else
		private let mLogLevel:  CNConfig.LogLevel	= .error
	#endif

	open override func visit(rootView view: KCRootView){
		guard getLimitSize(rootView: view) else {
			return
		}

		let coreview: KCInterfaceView = view.getCoreView()
		coreview.accept(visitor: self)
		self.visit(coreView: view)
	}

	private func getLimitSize(rootView root: KCRootView) -> Bool {
		#if os(OSX)
		if let win = root.window {
			mLimitSize = win.contentMaxSize
		} else {
			if let bounds = KCScreen.shared.contentBounds {
				mLimitSize = bounds.size
			} else {
				CNLog(logLevel: .error, message: "Failed to get limit window size", atFunction: #function, inFile: #file)
				return false
			}
		}
		#else
		if let bounds = KCScreen.shared.contentBounds {
			mLimitSize = bounds.size
		} else {
			if let bounds = KCScreen.shared.contentBounds {
				mLimitSize = bounds.size
			} else {
				CNLog(logLevel: .error, message: "Failed to get limit screen size", atFunction: #function, inFile: #file)
				return false
			}
		}
		#endif
		return true
	}

	open override func visit(stackView view: KCStackView){
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
		self.visit(coreView: view)
	}

	open override func visit(labeledStackView view: KCLabeledStackView){
		view.contentsView.accept(visitor: self)
		self.visit(coreView: view)
	}

	open override func visit(coreView view: KCInterfaceView){
		/* Do nothing */
	}

	private func checkSize(coreView view: KCInterfaceView) {
		let csize = view.intrinsicContentSize
		if csize.width > mLimitSize.width {
			CNLog(logLevel: mLogLevel,
			      message: "Contents width over limit size (\(csize.width) > \(mLimitSize.width)): at \(view)",
			      atFunction: #function, inFile: #file)
		}
		if csize.height > mLimitSize.height {
			CNLog(logLevel: mLogLevel,
			      message: "Contents height over limit size (\(csize.height) > \(mLimitSize.height)): at \(view)",
			      atFunction: #function, inFile: #file)
		}
	}
}

