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

		let symbol = CNSymbol.shared
		let img0 = symbol.URLOfSymbol(type: .characterA)
		let collectdata = CNCollection()
		collectdata.add(header: "", footer: "", items: [
					.image(img0)
		])

		let collectview = KCCollectionView()
		collectview.store(data: collectdata)
		stackview.addArrangedSubView(subView: collectview)

		let buttonview = KCButton()
		buttonview.value = .text("Hello")
		stackview.addArrangedSubView(subView: buttonview)

		return stackview
	}
}

