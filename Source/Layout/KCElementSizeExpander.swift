/**
 * @file	KCElementSizeExpander.swift
 * @brief	Define KCElementSizeExpander class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCElementSizeExpander: KCViewVisitor
{
	private var mParentSize: KCSize

	public init(parentSize size: KCSize) {
		mParentSize = size
	}

	open override func visit(rootView view: KCRootView){
		view.resize(mParentSize)
		let coreview: KCCoreView = view.getCoreView()
		coreview.accept(visitor: self)
	}

	open override func visit(stackView view: KCStackView){
		/* Visit subview first */
		let subviews = view.arrangedSubviews()
		for subview in subviews {
			subview.accept(visitor: self)
		}
		/* Expand elements */
		let esize = view.frame.size
		switch view.axis {
		case .horizontal:
			let eheight = esize.height
			for subview in subviews {
				let osize = subview.frame.size
				let nsize = KCSize(width: osize.width, height: max(eheight, osize.height))
				subview.resize(nsize)
			}
		case .vertical:
			let ewidth  = esize.width
			for subview in subviews {
				let osize = subview.frame.size
				let nsize = KCSize(width: max(ewidth, osize.width), height: osize.height)
				subview.resize(nsize)
			}
		@unknown default:
			NSLog("Unknown case condition")
		}
	}

	open override func visit(labeledStackView view: KCLabeledStackView) {
		view.contentsView.accept(visitor: self)
	}

	open override func visit(coreView view: KCCoreView){
		/* do nothing */
	}
}


