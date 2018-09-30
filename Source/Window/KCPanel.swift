/**
 * @file	KCPanel.swift
 * @brief	Define KCPanel class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(OSX)
import AppKit
#else
import UIKit
#endif
import Foundation

public class KCPanel
{
	private var mViewController: KCViewController

	public init(viewController vcont: KCViewController){
		mViewController = vcont
	}
	
	public func selectInputFile(title ttext: String, documentTypes allowedUTIs: [String]) -> URL?
	{
		#if os(OSX)
			/* get preference and collect extensions for given UTIs */
			let pref = KCPreference.shared.documentTypePreference
			let exts = pref.fileExtensions(forUTIs: allowedUTIs)
			if exts.count > 0 {
				if let url = URL.openPanel(title: ttext, selection: .SelectFile, fileTypes: exts) {
					return url
				}
			}
			return nil
		#else
			// Do any additional setup after loading the view, typically from a nib.
			let picker = KCDocumentPickerViewController(documentTypes: allowedUTIs, in: .import)
			mViewController.present(picker, animated: true, completion: {
				() -> Void in
			})
			return picker.waitResult()
		#endif
	}

	public func selectInputFile(title ttext: String, fileExtensions exts: [String]) -> URL?
	{
		#if os(OSX)
			if exts.count > 0 {
				if let url = URL.openPanel(title: ttext, selection: .SelectFile, fileTypes: exts) {
					return url
				}
			}
			return nil
		#else
			let pref = KCPreference.shared.documentTypePreference
			let utis = pref.UTIs(forExtensions: exts)
			let picker = KCDocumentPickerViewController(documentTypes: utis, in: .import)
			mViewController.present(picker, animated: true, completion: {
				() -> Void in
			})
			return picker.waitResult()
		#endif
	}

	public func selectInputDirectory(title ttext: String) -> URL?
	{
		#if os(OSX)
		if let url = URL.openPanel(title: ttext, selection: .SelectDirectory, fileTypes: []) {
			return url
		}
		#endif
		return nil
	}
}

