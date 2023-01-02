/**
 * @file	SingleViewController.swift
 * @brief	Define SingleViewController class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import KiwiControls
import UIKit

public class SingleViewController: KCSingleViewController
{
	public enum ViewType {
		case firstView
		case secondView

		public var description: String {
			get {
				let result: String
				switch self {
				case .firstView:	result = "firstView"
				case .secondView:	result  = "secondView"
				}
				return result
			}
		}
	}

	private var mViewType	: ViewType
	private var mURLLabel	: KCTextEdit?				= nil
	private var mPicker	: KCDocumentPickerViewController?	= nil

	public init(viewType type: ViewType, parentViewController parent: KCMultiViewController) {
		mViewType = type
		super.init(parentViewController: parent)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func loadContext() -> KCView? {
		let dmyrect   = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

		let label0    = KCTextEdit(frame: dmyrect)
		label0.text   = mViewType.description

		let button0   = KCButton(frame: dmyrect)
		button0.value = .text("OK")

		switch mViewType {
		case .firstView:
			button0.buttonPressedCallback = {
				() -> Void in
				NSLog("1st view: button pressed")
				self.selectInputURL()
			}
		case .secondView:
			button0.buttonPressedCallback = {
				() -> Void in
				NSLog("2nd view: button pressed")
			}
		}

		let box0 = KCStackView(frame: dmyrect)
		box0.axis		= .horizontal
		box0.alignment		= .fill
		box0.distribution	= .fill // .fillEqually
		box0.addArrangedSubViews(subViews: [label0, button0])

		let label1 = KCTextEdit(frame: dmyrect)
		label1.text = "<No URL>"
		mURLLabel = label1

		let box1 = KCStackView(frame: dmyrect)
		box1.axis		= .vertical
		box1.alignment		= .fill
		box1.distribution	= .fill
		box1.addArrangedSubViews(subViews: [box0, label1])

		return box1
	}

	private func selectInputURL() {
		CNLog(logLevel: .error, message: "selctInputFile", atFunction: #function, inFile: #file)

		let picker: KCDocumentPickerViewController
		if let p = mPicker {
			picker = p
		} else {
			let newpicker = KCDocumentPickerViewController(parentViewController: super.parentController)
			mPicker = newpicker
			picker  = newpicker
			
			picker.setCallbackFunction { (_ urlp: URL?) in
				NSLog("detect callback")
				if let url = urlp {
					self.mURLLabel?.text = url.path
				} else {
					self.mURLLabel?.text = "<canceled>"
				}
			}
		}

		let url = URL(fileURLWithPath: CNPreference.shared.userPreference.documentDirectory.path)
		picker.openPicker(URL: url)

		/*
		#if true
			parent.selectViewFile(title: "Select application", fileExtensions: ["ambpkg"], loaderFunction: {
				(_ url: URL) -> String? in
				return "second_view"
			})
		#else
			let utis = ["com.github.steelwheels.amber.application-package"]
			let selview: KCDocumentPickerViewController
			if let sel = mPicker {
				selview = sel
			} else {
				selview = KCDocumentPickerViewController(parentViewController: parent)
				selview.nextViewFunction = {
					(_ url: URL) -> String? in
					return "second_view"
				}
				mPicker = selview
			}
			selview.openPicker(UTIs: utis)
		#endif*/
	}

	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
}

