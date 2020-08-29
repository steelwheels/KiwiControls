/**
 * @file	KCViewDumper.swift
 * @brief	Define KCViewDumper class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCViewDumper: KCViewVisitor
{
	private var mSection:	CNTextSection

	public override init(console cons: CNConsole){
		mSection	= CNTextSection()
		super.init(console: cons)
	}

	public func dump(view v: KCView){
		v.accept(visitor: self)
		log(type: .debug, text: mSection, file: #file, line: #line, function: #function)
	}

	open override func visit(rootView view: KCRootView){
		/* Allocate section for root view */
		visit(coreView: view)
		let section = mSection
		/* Allocate sections for children */
		for subview in view.subviews {
			if let v = subview as? KCView {
				v.accept(visitor: self)
				section.add(text: mSection)
			}
		}
		mSection = section
	}

	open override func visit(stackView view: KCStackView){
		/* Allocate section for stack */
		visit(coreView: view)

		let axisdesc = view.axis.description
		mSection.add(text: CNTextLine(string: "axis:  " + axisdesc))

		let algndesc = view.alignment.description
		mSection.add(text: CNTextLine(string: "alignment:  " + algndesc))

		let distdesc = view.distribution.description
		mSection.add(text: CNTextLine(string: "distribution:  " + distdesc))

		let section = mSection
		/* Allocate sections for children */
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
			section.add(text: mSection)
		}
		mSection = section
	}

	open override func visit(labeledStackView view: KCLabeledStackView){
		/* Allocate section for stack */
		visit(coreView: view)
		let cursection = mSection

		/* Visit contents */
		view.contentsView.accept(visitor: self)
		cursection.add(text: mSection)

		mSection = cursection
	}

	open override func visit(navigationBar view: KCNavigationBar) {
		visit(coreView: view)

		let title = view.title
		mSection.add(string: "title: " + title)

		let lefttitle = view.leftButtonTitle
		mSection.add(string: "leftButtonTitle : " + lefttitle)

		let righttitle = view.rightButtonTitle
		mSection.add(string: "rightButtonTitle : " + righttitle)
	}

	open override func visit(spriteView view: KCSpriteView) {
		visit(coreView: view)

		let fsection = CNTextSection()
		fsection.header = "field {" ; fsection.footer = "}"
		fsection.add(text: CNTextLine(string: "physical_size: \(view.frame.size.description)"))
		fsection.add(text: CNTextLine(string: "logical_size:  \(view.logicalSize.description)"))
		mSection.add(text: fsection)
	}

	open override func visit(terminalView view: KCTerminalView) {
		visit(coreView: view)

		let fsection = CNTextSection()
		fsection.header = "CLI {" ; fsection.footer = "}"
		let colnum = view.currentColumnNumbers
		let rownum = view.currentRowNumbers
		fsection.add(text: CNTextLine(string: "colmun-num: \(colnum), row-num: \(rownum)"))
		let font    = view.font
		fsection.add(string: "font:\(font.fontName))")
		mSection.add(text: fsection)
	}

	open override func visit(popupMenu view: KCPopupMenu) {
		visit(coreView: view)

		let fsection = CNTextSection()
		fsection.header = "items {" ; fsection.footer = "}"
		let titles = view.itemTitles()
		for title in titles {
			fsection.add(string: title)
		}
		mSection.add(text: fsection)
	}

	open override func visit(coreView view: KCCoreView){
		let section = CNTextSection()

		section.header = "class :" + String(describing: type(of: view)) + " {"
		section.footer = "}"

		let framedesc  = view.frame.description
		section.add(text: CNTextLine(string: "frame:         " + framedesc))

		let boundsdesc = view.bounds.description
		section.add(text: CNTextLine(string: "bounds:        " + boundsdesc))

		let sizedesc   = view.intrinsicContentSize.description
		section.add(text: CNTextLine(string: "intrinsicSize: " + sizedesc))

		let doauto: String
		if view.translatesAutoresizingMaskIntoConstraints {
			doauto = "No"
		} else {
			doauto = "Yes"
		}
		section.add(text: CNTextLine(string: "do-autolayout: " + doauto))

		let doautoresize: String
		if view.autoresizesSubviews {
			doautoresize = "Yes"
		} else {
			doautoresize = "No"
		}
		section.add(text: CNTextLine(string: "do-autoresuze: " + doautoresize))

		#if os(OSX)
			if let core: KCView = view.getCoreView() {
				let accresp = core.acceptsFirstResponder
				section.add(text: CNTextLine(string: "responder: accept=\(accresp)"))
			}
		#else
			let is1stresp  = view.isFirstResponder
			section.add(text: CNTextLine(string: "responder: is1st=\(is1stresp)"))
		#endif

		let (hexp, vexp) = view.expandability()
		section.add(text: CNTextLine(string: "expansion-priority: h:\(hexp.description()) "
								       + "v:\(vexp.description())"))

		let constsect = CNTextSection()
		constsect.header = "constraints {"
		constsect.footer = "}"
		for constraint in view.constraints {
			let consttxt = constraintDescription(constraint: constraint, ownerView: view, coreView: view.getCoreView())
			constsect.add(text: consttxt)
		}
		section.add(text: constsect)

		mSection = section
	}

	private func constraintDescription(constraint constr: NSLayoutConstraint, ownerView owner: KCCoreView, coreView core: KCView) -> CNText {
		var result = "{"
		if constr.isActive {
			if let item = constr.firstItem as? KCView {
				result += "from-item:" + constraintItemDescription(item: item, attribute: constr.firstAttribute, ownerView: owner, coreView: core) + " "
			}
			if let item = constr.secondItem as? KCView {
				result += "to-item:" + constraintItemDescription(item: item, attribute: constr.secondAttribute, ownerView: owner, coreView: core) + " "
			}
			result += "multiplier:\(constr.multiplier) "
			result += "constant:\(constr.constant)"
		} else {
			result += "inactive"
		}
		result += "}"
		return CNTextLine(string: result)
	}

	private func constraintItemDescription(item view: KCView, attribute attr: NSLayoutConstraint.Attribute, ownerView owner: KCCoreView, coreView core: KCView) -> String {
		let ident: String
		if view == owner {
			ident = "self"
		} else if view == core {
			ident = "core"
		} else {
			ident = view.description
		}
		let attrstr = NSLayoutConstraint.attributeDescription(attribute: attr)
		return ident + "." + attrstr
	}
}

