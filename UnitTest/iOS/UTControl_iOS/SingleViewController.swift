/**
 * @file	SingleViewController.swift
 * @brief	Define SingleViewController class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import UIKit

class SingleViewController: KCSingleViewController
{
	open override func loadContext() -> KCView? {
		let stackview = KCStackView()
		stackview.axis = .vertical

		let symbol  = CNSymbol.character
		let imgview = KCImageView()
		imgview.image = symbol.load(size: .regular)
		stackview.addArrangedSubView(subView: imgview)

		let collectdata = CNCollection()
		collectdata.add(header: "", footer: "", items: [
			.chevronBackward,
			.chevronForward
		])

		let collectview = KCCollectionView()
		collectview.store(data: collectdata)
		collectview.isSelectable = true
		collectview.set(selectionCallback: {
			(_ section: Int, _ item: Int) -> Void in
			NSLog("selected section=\(section), item=\(item)")
		})
		stackview.addArrangedSubView(subView: collectview)


		let buttonview = KCButton()
		buttonview.value = .text("Hello")
		stackview.addArrangedSubView(subView: buttonview)

		return stackview
	}
}

