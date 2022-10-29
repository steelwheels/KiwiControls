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
		#if os(iOS)
		adjustRootSize(rootView: view, coreView: coreview)
		#endif
		coreview.accept(visitor: self)
	}

	#if os(iOS)
	private func adjustRootSize(rootView root: KCRootView, coreView core: KCInterfaceView) {
		let coresize = CGSize(width:  root.frame.size.width  - core.frame.origin.x,
				      height: root.frame.size.height - core.frame.origin.y)
		core.setFrame(size: coresize)
	}
	#endif

	open override func visit(stackView view: KCStackView){
		#if os(iOS)
		//adjustStackView(stackView: view)
		#endif
		/* First, resize members */
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
	}

	#if os(iOS)
	private func adjustStackView(stackView stack: KCStackView) {
		switch stack.axis {
		case .horizontal:
			let height = stack.frame.height
			for subview in stack.arrangedSubviews() {
				let newsize = CGSize(width: subview.frame.width, height: height)
				subview.setFrameSize(newsize)
			}
		case .vertical:
			let width = stack.frame.width
			for subview in stack.arrangedSubviews() {
				let newsize = CGSize(width: width, height: subview.frame.height)
				subview.setFrameSize(newsize)
			}
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
		}
	}
	#endif

	open override func visit(labeledStackView view: KCLabeledStackView){
		view.contentsView.accept(visitor: self)
	}

	open override func visit(imageView view: KCImageView){
	}

	open override func visit(coreView view: KCInterfaceView){
		/* Do nothing */
	}
}

