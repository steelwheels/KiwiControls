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
	public enum LoaderFunction {
		case none
		case view(_ loader: (_ url: URL) -> KCSingleViewController?)
		case url(_ loader: (_ url: URL) -> Void)
	}

	private var mParentViewController:	KCMultiViewController
	private var mPickerView:		UIDocumentPickerViewController?
	private var mLoaderFunction:		LoaderFunction

	public init(parentViewController parent: KCMultiViewController) {
		mParentViewController	= parent
		mPickerView		= nil
		mLoaderFunction		= .none
	}

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
			picker = UIDocumentPickerViewController()
			mPickerView = picker
		}
		picker.delegate			= self
		picker.modalPresentationStyle	= .fullScreen
		picker.allowsMultipleSelection	= false
		mParentViewController.present(picker, animated: true, completion: nil)
	}

	public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		CNLog(logLevel: .detail, message: "Selected")
		if urls.count >= 1 {
			switch mLoaderFunction {
			case .none:
				break
			case .view(let ldrfunc):
				if let viewctrl = ldrfunc(urls[0]) {
					let cbfunc: KCMultiViewController.ViewSwitchCallback = { (_ val: CNValue) -> Void in }
					mParentViewController.pushViewController(viewController: viewctrl, callback: cbfunc)
				}
			case .url(let ldrfunc):
				ldrfunc(urls[0])
			}
		}
	}

	public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		CNLog(logLevel: .detail, message: "Canceled")
	}
}

#endif // os(iOS)

