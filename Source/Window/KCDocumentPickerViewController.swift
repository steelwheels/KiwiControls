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
	private var mDone            = false
	private var mResultURL: URL? = nil

	public override init(documentTypes allowedUTIs: [String], in mode: UIDocumentPickerMode) {
		super.init(documentTypes: allowedUTIs, in: mode)
		self.delegate = self
	}

	public override init(url u: URL, in mode: UIDocumentPickerMode) {
		super.init(url: u, in: mode)
		self.delegate = self
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func waitResult() -> URL? {
		self.mDone = false
		while !(self.mDone) {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5)) /* 0.5 second */
		}
		return mResultURL
	}

	public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		if urls.count == 1 {
			mResultURL = urls[0]
		} else {
			mResultURL = nil
		}
		self.mDone = true
	}

	public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		self.mResultURL = nil
		self.mDone      = true
	}
}

#endif



