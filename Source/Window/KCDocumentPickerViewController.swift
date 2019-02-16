/**
 * @file	KCDocumentPickerViewController.swift
 * @brief	Define KCDocumentPickerViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(iOS)

import CoconutData
import UIKit
import Foundation

@objc public class KCDocumentPickerViewController: NSObject, UIDocumentPickerDelegate
{
	private var mParentViewController:	KCMultiViewController
	private var mPickerView:		UIDocumentPickerViewController?

	public var nextViewFunction: 		((_ url: URL) -> String?)?

	public init(parentViewController parent: KCMultiViewController) {
		mParentViewController	= parent
		mPickerView		= nil
		nextViewFunction	= nil
	}

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func openPicker(UTIs utis: Array<String>) {
		/* Open document picker */
		let picker: UIDocumentPickerViewController
		if let p = mPickerView {
			picker = p
		} else {
			picker = UIDocumentPickerViewController(documentTypes: utis, in: .import)
			mPickerView = picker
		}
		picker.delegate			= self
		picker.modalPresentationStyle	= .fullScreen
		picker.allowsMultipleSelection	= false
		mParentViewController.present(picker, animated: true, completion: nil)
	}

	public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		CNLog(type: .Normal, message: "Selected", place: #function)
		if urls.count >= 1, let nextfunc = nextViewFunction {
			if let viewname = nextfunc(urls[0]) {
				if !mParentViewController.pushViewController(byName: viewname) {
					CNLog(type: .Error, message: "Failed to push view \"\(viewname)\"", place: #function)
				}
			}
		}
	}

	public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		CNLog(type: .Normal, message: "Canceled", place: #function)
	}
}

#endif // os(iOS)

