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
	private var mAlreadySelected	: Bool		= false
	private var mResult		: URL?		= nil

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
		self.delegate = self
		self.modalPresentationStyle  = .fullScreen
		self.allowsMultipleSelection = false
	}

	public func present(in vcont: KCViewController){
		mAlreadySelected = false
		mResult		 = nil
		NSLog("Wait for done")
		vcont.present(self, animated: true, completion: nil)
	}

	public func waitReturnValue() -> URL? {
		NSLog("Wait return value ... Begin")
		while !mAlreadySelected {
			RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5)) /* 0.5 second */
		}
		NSLog("Wait return value ... End")
		return mResult
	}

	public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		NSLog("documentPicker: Selected")
		mAlreadySelected = true
		if urls.count >= 1 {
			mResult = urls[0]
		} else {
			NSLog("No valid URL at \(#function)")
		}
	}

	public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		NSLog("documentPicker: Cancelled")
		mAlreadySelected = true
		mResult		 = nil
	}
}

/*
public class KCDocumentPickerViewController: KCSingleViewController, UIDocumentPickerDelegate
{
	private var mPickerView:	UIDocumentPickerViewController?	= nil
	private var mURLs: 		Array<URL> 			= []

	public static let ViewName = "_selectorView"

	public class func allocateToParentView(parentViewController parent: KCMultiViewController, console cons: CNConsole, doVerbose doverb: Bool){
		let newview = KCDocumentPickerViewController(parentViewController: parent, console: cons, doVerbose: doverb)
		parent.add(name: KCDocumentPickerViewController.ViewName, viewController: newview)
	}

	public class func encodeParameter(UTIs utis: Array<String>) -> CNNativeValue {
		var utistrs: Array<CNNativeValue> = []
		for uti in utis {
			utistrs.append(.stringValue(uti))
		}
		let dict: CNNativeValue = .dictionaryValue(["UTIs": .arrayValue(utistrs)])
		return dict
	}

	private func decodeParameter() -> Array<String> { // UTIs
		var result: Array<String> = []
		if let dict = parameter.toDictionary() {
			if let arrp = dict["UTIs"] {
				if let arr = arrp.toArray() {
					for elm in arr {
						if let elmstr = elm.toString() {
							result.append(elmstr)
						}
					}
				}
			}
		}
		if result.count == 0 {
			NSLog("No UTI parameter at \(#function)")
		}
		return result
	}

	private func encodeResult(URLs urls: Array<URL>) -> CNNativeValue {
		var arr: Array<CNNativeValue> = []
		for url in urls {
			arr.append(.stringValue(url.absoluteString))
		}
		return .dictionaryValue(["URLs": .arrayValue(arr)])
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
		let utis    = decodeParameter()
		mPickerView = UIDocumentPickerViewController(documentTypes: utis, in: .import)
		mPickerView?.delegate = self
		mPickerView?.modalPresentationStyle = .formSheet
	}

	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//NSLog("KCDocumentPickerViewController: start")
		if let picker = mPickerView {
			self.present(picker, animated: true, completion: {
				NSLog("documentPicker: presented")
			})
		}
	}

	public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		NSLog("documentPicker: Selected")
		finish(URLs: urls)
	}

	public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		NSLog("documentPicker: Cancelled")
		finish(URLs: [])
	}

	private func finish(URLs urls: Array<URL>) {
		if let parent = self.parentController {
			let retval = self.encodeResult(URLs: urls)
			parent.popViewController(returnValue: retval)
		} else {
			NSLog("No parent at \(#function)")
		}
	}
}
*/

#endif



