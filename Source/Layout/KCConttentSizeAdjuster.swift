/**
 * @file	KCContentSizeAdjuster.swift
 * @brief	Define KCContentSizeAdjuster class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData

public class KCContentSizeAdjuster: KCViewVisitor
{
	open override func visit(rootView view: KCRootView){
		let coreview: KCInterfaceView = view.getCoreView()
		coreview.accept(visitor: self)
	}

	open override func visit(stackView view: KCStackView){
		/* First, resize members */
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
	}

	open override func visit(labeledStackView view: KCLabeledStackView){
		view.contentsView.accept(visitor: self)
	}

	open override func visit(imageView view: KCImageView){
		view.adjustContentSize()
	}

	open override func visit(coreView view: KCInterfaceView){
		/* Do nothing */
	}
}

