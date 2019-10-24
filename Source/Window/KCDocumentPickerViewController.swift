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

@objc public class KCDocumentPickerViewController: NSObject, CNLogging, UIDocumentPickerDelegate
{
	public enum LoaderFunction {
		case none
		case view(_ loader: (_ url: URL) -> String?)
		case url(_ loader: (_ url: URL) -> Void)
	}

	private var mParentViewController:	KCMultiViewController
	private var mPickerView:		UIDocumentPickerViewController?
	private var mLoaderFunction:		LoaderFunction
	private var mConsole:			CNConsole?

	public init(parentViewController parent: KCMultiViewController, console cons: CNConsole?) {
		mParentViewController	= parent
		mConsole		= cons
		mPickerView		= nil
		mLoaderFunction		= .none
	}

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var console: CNConsole? {
		get { return mConsole }
	}

	public func setLoaderFunction(loader ldr: LoaderFunction){
		mLoaderFunction = ldr
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
		log(type: .flow, string: "Selected", file: #file, line: #line, function: #function)
		if urls.count >= 1 {
			switch mLoaderFunction {
			case .none:
				break
			case .view(let ldrfunc):
				if let viewname = ldrfunc(urls[0]) {
					if !mParentViewController.pushViewController(byName: viewname) {
						log(type: .error, string: "Failed to push view \"\(viewname)\"", file: #file, line: #line, function: #function)
					}
				}
			case .url(let ldrfunc):
				ldrfunc(urls[0])
			}
		}
	}

	public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		log(type: .flow, string: "Canceled", file: #file, line: #line, function: #function)
	}
}

#endif // os(iOS)

