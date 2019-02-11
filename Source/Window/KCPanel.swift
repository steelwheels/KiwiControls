/**
 * @file	KCPanel.swift
 * @brief	Define KCPanel class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
#if os(OSX)
import AppKit
#else
import UIKit
#endif
import Foundation

public class KCPanel
{
	private var mViewController:	KCViewController
	private var mConsole:		CNConsole
	private var mDoVerbose:		Bool

	public init(viewController vcont: KCViewController, console cons: CNConsole, doVerbose doverb: Bool){
		mViewController = vcont
		mConsole	= cons
		mDoVerbose	= doverb
	}
	
	public func selectInputFile(title ttext: String, documentTypes allowedUTIs: [String], completion complfunc: @escaping (_ url: URL?) -> Void)
	{
		#if os(OSX)
			/* get preference and collect extensions for given UTIs */
			let pref = KCPreference.shared.documentTypePreference
			let exts = pref.fileExtensions(forUTIs: allowedUTIs)
			if exts.count > 0 {
				if let url = URL.openPanel(title: ttext, selection: .SelectFile, fileTypes: exts) {
					complfunc(url)
					return
				}
			}
			complfunc(nil)
		#else
			KCDocumentPickerViewController.selectInputFile(parentViewController: mViewController, documentTypes: allowedUTIs, in: .import, completion: complfunc)
		#endif
	}

	public func selectInputFile(title ttext: String, fileExtensions exts: [String], completion complfunc: @escaping (_ url: URL?) -> Void)
	{
		#if os(OSX)
			if exts.count > 0 {
				if let url = URL.openPanel(title: ttext, selection: .SelectFile, fileTypes: exts) {
					complfunc(url)
				}
			}
			complfunc(nil)
		#else
			let pref = KCPreference.shared.documentTypePreference
			let utis = pref.UTIs(forExtensions: exts)
			KCDocumentPickerViewController.selectInputFile(parentViewController: mViewController, documentTypes: utis, in: .import, completion: complfunc)
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

