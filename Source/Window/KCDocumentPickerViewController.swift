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

public class KCDocumentPickerViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate
{
	private var mCompletion: ((_ url: URL?) -> Void)? = nil

	public class func selectInputFile(parentViewController parent: KCViewController, documentTypes allowedUTIs: [String], in mode: UIDocumentPickerMode, completion compl: @escaping (_ url: URL?) -> Void)
	{
		let picker = KCDocumentPickerViewController(documentTypes: allowedUTIs, in: mode)
		picker.mCompletion = compl
		parent.present(picker, animated: false, completion: nil)
	}

	public override init(url: URL, in mode: UIDocumentPickerMode) {
		super.init(url: url, in: mode)
		setup()
	}

	public override init(urls: [URL], in mode: UIDocumentPickerMode) {
		super.init(urls: urls, in: mode)
		setup()
	}

	public override init(documentTypes allowedUTIs: [String], in mode: UIDocumentPickerMode) {
		super.init(documentTypes: allowedUTIs, in: mode)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup(){
		mCompletion			= nil
		self.delegate			= self
		self.modalPresentationStyle	= .fullScreen
		self.allowsMultipleSelection	= false
	}

	public override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		CNLog(type: .Normal, message: "viewDidiDisappear", place: #function)
	}

	public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		CNLog(type: .Normal, message: "Selected", place: #function)
		if urls.count >= 1 {
			callCompletion(URL: urls[0])
		} else {
			CNLog(type: .Error, message: "No valid URL", place: #function)
			callCompletion(URL: nil)
		}
	}

	public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		CNLog(type: .Normal, message: "Cancelled", place: #function)
		callCompletion(URL: nil)
	}

	private func callCompletion(URL url: URL?) {
		if let comp = mCompletion {
			CNLog(type: .Normal, message: "Call callback", place: #function)
			comp(url)
		}
	}
}

#endif // os(iOS)

