/**
 * @file	KCSizeMinimizer.swift
 * @brief	Define KCSizeMinimizer class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSizeMinimizer: KCViewVisitor
{
	private var mParentSize: KCSize = KCSize.zero
	private var mResultSize: KCSize = KCSize.zero

	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()

		mParentSize = view.frame.size
		coreview.accept(visitor: self)
		coreview.resize(mResultSize)
	}

	open override func visit(stackView view: KCStackView){
		/* First, resize members */
		var newparent = CGSize(width: 0.0, height: 0.0)
		switch view.axis {
		case .horizontal:
			var subparent = mParentSize
			newparent.height = subparent.height
			for subview in view.arrangedSubviews() {
				mParentSize = subparent
				subview.accept(visitor: self)
				/* Reduce parent size */
				newparent.width += mResultSize.width
				if subparent.width > mResultSize.width {
					subparent.width -= mResultSize.width
				} else {
					log(type: .Error, string: "Minimize overflow (holizontal)", file: #file, line: #line, function: #function)
				}
			}
		case .vertical:
			var subparent = mParentSize
			newparent.width = subparent.width
			for subview in view.arrangedSubviews() {
				mParentSize = subparent
				subview.accept(visitor: self)
				/* Reduce parent size */
				newparent.height += mResultSize.height
				if subparent.height > mResultSize.height {
					subparent.height -= mResultSize.height
				} else {
					log(type: .Error, string: "Minimize overflow (vertical)", file: #file, line: #line, function: #function)
				}
			}
		}

		/* Next resize it self */
		mParentSize = newparent
		mResultSize = view.sizeThatFits(mParentSize)
		view.resize(mResultSize)
	}

	open override func visit(coreView view: KCCoreView){
		mResultSize = view.sizeThatFits(mParentSize)
		view.resize(mResultSize)
	}
}

