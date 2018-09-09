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
	private var mConsole:	CNConsole

	public init(console cons: CNConsole){
		mSection	= CNTextSection()
		mConsole	= cons
	}

	public func dump(view v: KCView){
		v.accept(visitor: self)
		mSection.print(console: mConsole)
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

		let (hexp, vexp) = view.expansionPriorities()
		section.add(text: CNTextLine(string: "expansion-priority: h:\(hexp.description()) "
								       + "v:\(vexp.description())"))

		#if false
		let constsect = CNTextSection()
		constsect.header = "constraints {"
		constsect.footer = "}"
		for constraint in view.constraints {
			constsect.add(text: CNTextLine(string: "\(constraint)"))
		}
		section.add(text: constsect)
		#endif

		mSection = section
	}
}

