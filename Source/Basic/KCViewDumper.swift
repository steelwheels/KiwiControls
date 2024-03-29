/**
 * @file	KCViewDumper.swift
 * @brief	Define KCViewDumper class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
#if os(OSX)
import AppKit
#else
import UIKit
#endif
import Foundation

public class KCViewDumper: KCViewVisitor
{
	private var mSection:	CNTextSection

	public override init(){
		mSection	= CNTextSection()
	}

	public func dump(view v: KCView, console cons: CNConsole){
		v.accept(visitor: self)
		let txt = mSection.toStrings().joined(separator: "\n")
		cons.print(string: txt + "\n")
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

	open override func visit(tableView view: KCTableView){
		visit(coreView: view)

		let rownum = view.numberOfRows
		let colnum = view.numberOfColumns
		mSection.add(text: CNTextLine(string: "{rownum: \(rownum), colnum: \(colnum)}"))
	}

	open override func visit(collectionView view: KCCollectionView){
		visit(coreView: view)

		mSection.add(text: CNTextLine(string: "{sec-num: \(view.numberOfSections) }"))
		mSection.add(text: CNTextLine(string: "{col-num: \(view.numberOfColumuns) }"))
	}

	open override func visit(navigationBar view: KCNavigationBar) {
		visit(coreView: view)

		let title = view.title
		mSection.add(text: CNTextLine(string: "title: " + title))

		let lefttitle = view.leftButtonTitle
		mSection.add(text: CNTextLine(string: "leftButtonTitle : " + lefttitle))

		let righttitle = view.rightButtonTitle
		mSection.add(text: CNTextLine(string: "rightButtonTitle : " + righttitle))
	}

	open override func visit(terminalView view: KCTerminalView) {
		visit(coreView: view)

		let fsection = CNTextSection()

		let terminfo = view.terminalInfo
		fsection.header = "CLI {" ; fsection.footer = "}"
		let width  = terminfo.width
		let height = terminfo.height
		fsection.add(text: CNTextLine(string: "width: \(width), height: \(height)"))
		mSection.add(text: fsection)
	}

	open override func visit(textEdit view: KCTextEdit){
		visit(coreView: view)

		let fsection = CNTextSection()
		fsection.header = "textField {" ; fsection.footer = "}"
		fsection.add(text: CNTextLine(string: "text: \"\(view.text)\""))
		mSection.add(text: fsection)
	}

    open override func visit(labelView view: KCLabelView){
        visit(coreView: view)
        let fsection = CNTextSection()
        fsection.header = "label {" ; fsection.footer = "}"
        fsection.add(text: CNTextLine(string: "label:\(view.text))"))
        mSection.add(text: fsection)
    }

	open override func visit(textView view: KCTextView){
		visit(coreView: view)

		let fsection = CNTextSection()
		fsection.header = "textView {" ; fsection.footer = "}"
		//fsection.add(text: CNTextLine(string: "text: \"\(view.text)\""))
		mSection.add(text: fsection)
	}

	open override func visit(iconView view: KCIconView){
		visit(coreView: view)

		let fsection = CNTextSection()
		fsection.header = "icon {" ; fsection.footer = "}"
		fsection.add(text: CNTextLine(string: "size:\(view.frame.size.description))"))
		mSection.add(text: fsection)
	}

	open override func visit(imageView view: KCImageView){
		visit(coreView: view)
		let fsection = CNTextSection()
		fsection.header = "image {" ; fsection.footer = "}"
		if let img = view.image {
			fsection.add(text: CNTextLine(string: "size:\(img.size.description))"))
		} else {
			fsection.add(text: CNTextLine(string: "nil"))
		}
		mSection.add(text: fsection)
	}

	open override func visit(popupMenu view: KCPopupMenu) {
		visit(coreView: view)

		let fsection = CNTextSection()
		fsection.header = "items {" ; fsection.footer = "}"
		for item in view.allItems() {
			fsection.add(text: CNTextLine(string: item.title))
		}
		mSection.add(text: fsection)
	}

	open override func visit(graphics2DView view: KCGraphics2DView){
		let fsection = CNTextSection()
		fsection.header = "graphics2D {" ; fsection.footer = "}"
		mSection.add(text: fsection)
	}

	open override func visit(vectorGraphics view: KCVectorGraphics){
		let fsection = CNTextSection()
		fsection.header = "vector-graphics {" ; fsection.footer = "}"
		mSection.add(text: fsection)
	}

	open override func visit(coreView view: KCInterfaceView){
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
		section.add(text: CNTextLine(string: "do-autoresize-subviews: " + doautoresize))

		#if os(OSX)
			if let core: KCView = view.getCoreView() {
				let accresp = core.acceptsFirstResponder
				section.add(text: CNTextLine(string: "responder: accept=\(accresp)"))
			}
		#else
			let is1stresp  = view.isFirstResponder
			section.add(text: CNTextLine(string: "responder: is1st=\(is1stresp)"))
		#endif

		let exppri = view.expansionPriority()
		section.add(text: CNTextLine(string: "expansion-priority: "
			+ "holiz-hug:\(exppri.holizontalHugging.description()) "
			+ "holiz-comp:\(exppri.holizontalCompression.description()) "
			+ "vert-hug:\(exppri.verticalHugging.description())"
			+ "vert-comp:\(exppri.verticalCompression.description())"
		))

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

	private func constraintDescription(constraint constr: NSLayoutConstraint, ownerView owner: KCInterfaceView, coreView core: KCView) -> CNText {
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

	private func constraintItemDescription(item view: KCView, attribute attr: NSLayoutConstraint.Attribute, ownerView owner: KCInterfaceView, coreView core: KCView) -> String {
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

