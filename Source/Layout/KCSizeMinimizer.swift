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
	private var mRootSize:   KCSize
	private var mParentSize: KCSize = KCSize.zero
	private var mResultSize: KCSize = KCSize.zero

	public init(rootSize root: KCSize, console cons: CNConsole) {
		mRootSize = root
		super.init(console: cons)
	}

	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()

		/* do not use resize */
		view.frame.size  = mRootSize
		view.bounds.size = mRootSize
		mParentSize      = mRootSize

		coreview.accept(visitor: self)
		coreview.resize(mResultSize)
	}

	open override func visit(stackView view: KCStackView){
		/* Keep the current size */
		let subview    = view.arrangedSubviews()
		let axis       = view.axis
		var parentsize = mParentSize

		/* Categorize subviews by it's prioroty */
		let (highviews, lowviews, fixedviews) = categorizeSubviews(stackView: view)

		/* Visit fixed views first */
		let fdivsize = dividedSize(stackView: view, parentSize: parentsize, subviewCount: subview.count)
		for subview in fixedviews {
			mParentSize = fdivsize
			subview.accept(visitor: self)
			switch axis {
			case .horizontal: parentsize.width  = max(0.0, parentsize.width  - mResultSize.width )
			case .vertical:	  parentsize.height = max(0.0, parentsize.height - mResultSize.height)
			}
		}

		/* Visit low expandable views first */
		let ldivsize = dividedSize(stackView: view, parentSize: parentsize, subviewCount: lowviews.count + highviews.count)
		for subview in lowviews {
			mParentSize = ldivsize
			subview.accept(visitor: self)
			switch axis {
			case .horizontal: parentsize.width  = max(0.0, parentsize.width  - mResultSize.width )
			case .vertical:	  parentsize.height = max(0.0, parentsize.height - mResultSize.height)
			}
		}

		/* Visit high expandable views first */
		let hdivsize = dividedSize(stackView: view, parentSize: parentsize, subviewCount: highviews.count)
		for subview in highviews {
			mParentSize = hdivsize
			subview.accept(visitor: self)
			switch axis {
			case .horizontal: parentsize.width  = max(0.0, parentsize.width  - mResultSize.width )
			case .vertical:	  parentsize.height = max(0.0, parentsize.height - mResultSize.height)
			}
		}

		/* Merge subviews */
		var merged: CGSize = CGSize.zero
		switch view.axis {
		case .horizontal:
			for subview in view.arrangedSubviews() {
				merged.width  += subview.frame.size.width
				merged.height =  max(merged.height, subview.frame.size.height)
			}
		case .vertical:
			for subview in view.arrangedSubviews() {
				merged.width  =  max(merged.width, subview.frame.size.width)
				merged.height += subview.frame.size.height
			}
		}

		if merged.width > mParentSize.width {
			log(type: .Error, string: "Width overflow: \(merged.width) > \(mParentSize.width) ",
				file: #file, line: #line, function: #function)
		}
		if merged.height > mParentSize.height {
			log(type: .Error, string: "height overflow: \(merged.height) > \(mParentSize.height)",
				file: #file, line: #line, function: #function)
		}

		mResultSize = merged
		view.resize(merged)
	}

	open override func visit(coreView view: KCCoreView){
		mResultSize = view.minimumSize(mParentSize)
		view.resize(mResultSize)
	}

	private func categorizeSubviews(stackView stack: KCStackView) -> (Array<KCView>, Array<KCView>, Array<KCView>) {
		var highviews:   Array<KCView> = []
		var lowviews:    Array<KCView> = []
		var fixedviews:  Array<KCView> = []
		for subview in stack.arrangedSubviews() {
			if let subview = subview as? KCCoreView {
				let (hpri, vpri) = subview.expansionPriorities()
				switch stack.axis {
				case .horizontal:
					switch hpri {
					case .High:	highviews.append(subview)
					case .Low:	lowviews.append(subview)
					case .Fixed:	fixedviews.append(subview)
					}
				case .vertical:
					switch vpri {
					case .High:	highviews.append(subview)
					case .Low:	lowviews.append(subview)
					case .Fixed:	fixedviews.append(subview)
					}
				}
			} else {
				fatalError("Can not happen")
			}
		}
		return (highviews, lowviews, fixedviews)
	}

	private func dividedSize(stackView stack: KCStackView, parentSize size: CGSize, subviewCount subviewnum: Int) -> CGSize {
		if subviewnum > 1 {
			let width: 	CGFloat
			let height:	CGFloat
			switch stack.axis {
			case .horizontal:
				width  = size.width  / CGFloat(subviewnum)
				height = size.height
			case .vertical:
				width  = size.width
				height = size.height / CGFloat(subviewnum)
			}
			return CGSize(width: width, height: height)
		} else {
			return size
		}
	}
}

