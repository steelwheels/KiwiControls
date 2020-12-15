/**
 * @file	KCSetPrefferedWidth.swift
 * @brief	Define KCSetPrefferedWidth class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

#if os(OSX)
public class KCSetPrefferedWidth: KCViewVisitor
{
	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()
		coreview.accept(visitor: self)
	}

	open override func visit(stackView view: KCStackView){
		/* First, set members */
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
		/* Collect child text view */
		switch view.axis {
		case .horizontal:
			var diffwidth = view.frame.size.width
			var textviews: Array<KCTextEdit> = []
			for subview in view.arrangedSubviews() {
				if let txtview = subview as? KCTextEdit {
					textviews.append(txtview)
				}
				diffwidth -= subview.frame.size.width
			}
			if textviews.count > 0 && diffwidth > 0.0 {
				let delta = diffwidth / CGFloat(textviews.count)
				for txtview in textviews {
					txtview.preferredTextFieldWidth += delta
				}
			}
		case .vertical:
			break
		@unknown default:
			NSLog("Unknown case: \(#function)")
		}
	}

	open override func visit(labeledStackView view: KCLabeledStackView){
		view.contentsView.accept(visitor: self)
	}

	open override func visit(coreView view: KCCoreView){
		/* Do nothing */
	}
}
#endif

