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
	private var mConsole:		CNConsole
	private var mRootSize:		KCSize

	public init(rootSize size: KCSize, console cons: CNConsole){
		mRootSize = size
		mConsole  = cons
	}
	public func layout(rootView view: KCRootView){
		view.accept(visitor: self)
	}

	open override func visit(rootView view: KCRootView){
		/* Set size of window to root view
		 * The size of root view is NOT changed at the auto layout
		 */
		let space  = KCPreference.shared.layoutPreference.spacing
		let entire = KCRect(origin: KCPoint(x: 0.0, y: 0.0), size: mRootSize)
		let frame  = KCRect.insideRect(rect: entire, spacing: space)
		let bounds = KCRect(origin: KCPoint(x: 0.0, y: 0.0), size: frame.size)

		view.frame     = frame
		view.bounds    = bounds
		view.fixedSize = bounds.size
		view.setFixedSizeForLayout(size: bounds.size, spacing: space)

		/* Visit sub view */
		if let core: KCView = view.getCoreView() {
			core.accept(visitor: self)
		}
	}

	open override func visit(iconView view: KCIconView){
		/* Do nothing */
	}

	open override func visit(button view: KCButton){
		/* Do nothing */
	}

	open override func visit(checkBox view: KCCheckBox){
		/* Do nothing */
	}

	open override func visit(stepper view: KCStepper){
		/* Do nothing */
	}

	open override func visit(textField view: KCTextField){
		/* Do nothing */
	}

	open override func visit(textEdit view: KCTextEdit){
		/* Do nothing */
	}

	open override func visit(tableView view: KCTableView){
		/* Do nothing */
	}

	open override func visit(stackView view: KCStackView){
		/* Give constraint for each subviews */
		let dovert: Bool
		switch view.alignment {
		case .horizontal(_):
			dovert = true
		case .vertical(_):
			dovert = false
		}
		for subview in view.arrangedSubviews() {
			view.allocateSubviewLayout(subView: subview, forVerical: dovert)
		}

		/* Visit subviews */
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
	}

	open override func visit(consoleView view: KCConsoleView){
		/* Do nothing */
	}

	open override func visit(coreView view: KCCoreView){
		mConsole.error(string: "Unknown component: \(view) in KCLayouter")
	}
}

