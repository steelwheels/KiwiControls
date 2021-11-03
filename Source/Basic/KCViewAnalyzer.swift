/**
 * @file	KCViewAnalyzer.swift
 * @brief	Define KCViewAnalyzer class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import Foundation

public enum KCViewStructure {
	case none
	case bezierView
	case bitmapView
	case button
	case checkBox
	case collectionView
	case colorSelector
	case consoleView
	case graphics2D
	case iconView
	case imageView
	case labeledStack(Array<KCViewStructure>)		// (content-view)
	case navigationBar
	case popupMenu
	case rootView
	case stack(Array<KCViewStructure>)		// array of child views
	case stepper
	case table
	case terminalView
	case textEdit

	public func isSame(_ s0: KCViewStructure) -> Bool {
		let result: Bool
		switch self {
		case .none:
			switch s0 {
			case .none:		result = true
			default:		result = false
			}
		case .bezierView:
			switch s0 {
			case .bezierView:	result = true
			default:		result = false
			}
		case .bitmapView:
			switch s0 {
			case .bitmapView:	result = true
			default:		result = false
			}
		case .button:
			switch s0 {
			case .button:		result = true
			default:		result = false
			}
		case .checkBox:
			switch s0 {
			case .checkBox:		result = true
			default:		result = false
			}
		case .collectionView:
			switch s0 {
			case .collectionView:	result = true
			default:		result = false
			}
		case .colorSelector:
			switch s0 {
			case .colorSelector:	result = true
			default:		result = false
			}
		case .consoleView:
			switch s0 {
			case .consoleView:	result = true
			default:		result = false
			}
		case .graphics2D:
			switch s0 {
			case .graphics2D:	result = true
			default:		result = false
			}
		case .iconView:
			switch s0 {
			case .iconView:		result = true
			default:		result = false
			}
		case .imageView:
			switch s0 {
			case .imageView:	result = true
			default:		result = false
			}
		case .labeledStack(let c0):
			switch s0 {
			case .labeledStack(let c1):
				if c0.count == c1.count {
					var cres = true
					for i in 0..<c0.count {
						if !c0[i].isSame(c1[i]) {
							cres = false
							break
						}
					}
					result = cres
				} else {
					result = false
				}
			default:		result = false
			}
		case .navigationBar:
			switch s0 {
			case .navigationBar:	result = true
			default:		result = false
			}
		case .popupMenu:
			switch s0 {
			case .popupMenu:	result = true
			default:		result = false
			}
		case .rootView:
			switch s0 {
			case .rootView:		result = true
			default:		result = false
			}
		case .stack(let c0):
			switch s0 {
			case .stack(let c1):
				if c0.count == c1.count {
					var cres = true
					for i in 0..<c0.count {
						if !c0[i].isSame(c1[i]) {
							cres = false
							break
						}
					}
					result = cres
				} else {
					result = false
				}
			default:		result = false
			}
		case .stepper:
			switch s0 {
			case .stepper:		result = true
			default:		result = false
			}
		case .table:
			switch s0 {
			case .table:		result = true
			default:		result = false
			}
		case .terminalView:
			switch s0 {
			case .terminalView:	result = true
			default:		result = false
			}
		case .textEdit:
			switch s0 {
			case .textEdit:		result = true
			default:		result = false
			}
		}
		return result
	}
}

public class KCViewAnalyzer: KCViewVisitor
{
	public var result: KCViewStructure

	public static func analyze(view v: KCView) -> KCViewStructure {
		let analyzer = KCViewAnalyzer()
		v.accept(visitor: analyzer)
		return analyzer.result
	}

	public override init(){
		result = .none
	}

	public override func visit(rootView view: KCRootView){
		result = .rootView
	}

	public override func visit(button view: KCButton){
		result = .button
	}

	public override func visit(checkBox view: KCCheckBox){
		result = .checkBox
	}

	public override func visit(stepper view: KCStepper){
		result = .stepper
	}

	public override func visit(textEdit view: KCTextEdit){
		result = .textEdit
	}

	public override func visit(tableView view: KCTableView){
		result = .table
	}

	public override func visit(collectionView view: KCCollectionView){
		result = .collectionView
	}

	public override func visit(stackView view: KCStackView){
		var children: Array<KCViewStructure> = []
		for subview in view.arrangedSubviews() {
			let analyzer = KCViewAnalyzer()
			subview.accept(visitor: analyzer)
			children.append(analyzer.result)
		}
		result = .stack(children)
	}

	public override func visit(labeledStackView view: KCLabeledStackView) {
		let analyzer = KCViewAnalyzer()
		view.contentsView.accept(visitor: analyzer)
		switch analyzer.result {
		case .stack(let children):
			result = .labeledStack(children)
		default:
			CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			result = .labeledStack([analyzer.result])
		}
	}

	public override func visit(consoleView view: KCConsoleView){
		result = .consoleView
	}

	public override func visit(terminalView view: KCTerminalView){
		result = .terminalView
	}

	public override func visit(textView view: KCTextView){
		result = .consoleView
	}

	public override func visit(iconView view: KCIconView){
		result = .iconView
	}

	public override func visit(imageView view: KCImageView){
		result = .imageView
	}

	public override func visit(navigationBar view: KCNavigationBar){
		result = .navigationBar
	}

	public override func visit(colorSelector view: KCColorSelector){
		result = .colorSelector
	}

	public override func visit(popupMenu view: KCPopupMenu){
		result = .colorSelector
	}

	public override func visit(bezierView view: KCBezierView){
		result = .popupMenu
	}

	public override func visit(graphics2DView view: KCGraphics2DView){
		result = .graphics2D
	}

	public override func visit(bitmapView view: KCBitmapView){
		result = .bitmapView
	}

	public override func visit(coreView view: KCInterfaceView){
		CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
		result = .none
	}
}

public func KCIsSameView(view0 v0: KCView, view1 v1: KCView) -> Bool {
	let s0 = KCViewAnalyzer.analyze(view: v0)
	let s1 = KCViewAnalyzer.analyze(view: v1)
	return s0.isSame(s1)
}
