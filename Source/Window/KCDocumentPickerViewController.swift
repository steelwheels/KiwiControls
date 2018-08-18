/**
 * @file	KCDocumentPickerViewController.swift
 * @brief	Define KCDocumentPickerViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(iOS)

import UIKit
import Foundation

public class KCDocumentPickerViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate
{
	private var mResultURLs: [URL] = []

	public override init(documentTypes allowedUTIs: [String], in mode: UIDocumentPickerMode) {
		super.init(documentTypes: allowedUTIs, in: mode)
		setup()
	}

	public override init(url u: URL, in mode: UIDocumentPickerMode) {
		super.init(url: u, in: mode)
		setup()
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup(){
		self.delegate = self
	}

	public var result: [URL] {
		get { return mResultURLs }
	}

	public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		mResultURLs = urls
	}

	public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		mResultURLs = []
	}
}

#endif



