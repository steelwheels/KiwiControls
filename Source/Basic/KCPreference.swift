/**
 * @file	KCPreference.swift
 * @brief	Define KCPreference class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData
import Foundation

public class KCPreference
{
	private static var 	mShared: KCPreference? = nil
	public static var	shared: KCPreference {
		get {
			if let obj = mShared {
				return obj
			} else {
				let newobj = KCPreference()
				mShared = newobj
				return newobj
			}
		}
	}

	public var documentTypePreference:	KCDocumentTypePreference
	public var layoutPreference:		KCLayoutPreference
	public var terminalPreference:		KCTerminalPreference

	public init(){
		documentTypePreference	= KCDocumentTypePreference()
		layoutPreference   	= KCLayoutPreference()
		terminalPreference 	= KCTerminalPreference()
	}
}

public class KCDocumentTypePreference
{
	private var mDocumentTypes: Dictionary<String, Array<String>>	// UTI, extension

	public init() {
		mDocumentTypes = [:]

		if let infodict = Bundle.main.infoDictionary {
			/* Import document types */
			if let imports = infodict["UTImportedTypeDeclarations"] as? Array<AnyObject> {
				collectTypeDeclarations(typeDeclarations: imports)
			}
		}
	}

	private func collectTypeDeclarations(typeDeclarations decls: Array<AnyObject>){
		for decl in decls {
			if let dict = decl as? Dictionary<String, AnyObject> {
				if dict.count > 0 {
					collectTypeDeclaration(typeDeclaration: dict)
				}
			} else {
				CNLog(type: .Error, message: "[Error] Invalid description: \(decl)", place: #file)
			}
		}
	}

	private func collectTypeDeclaration(typeDeclaration decl: Dictionary<String, AnyObject>){
		guard let uti = decl["UTTypeIdentifier"] as? String else {
			CNLog(type: .Error, message: "No UTTypeIdentifier", place: #file)
			return
		}
		guard let tags = decl["UTTypeTagSpecification"] as? Dictionary<String, AnyObject> else {
			CNLog(type: .Error, message: "No UTTypeTagSpecification", place: #file)
			return
		}
		guard let exts = tags["public.filename-extension"] as? Array<String> else {
			CNLog(type: .Error, message: "No public.filename-extension", place: #file)
			return
		}
		mDocumentTypes[uti] = exts
	}

	public var UTIs: Array<String> {
		get {
			return Array(mDocumentTypes.keys)
		}
	}

	public func fileExtensions(forUTIs utis: [String]) -> [String] {
		var result: [String] = []
		for uti in utis {
			if let exts = mDocumentTypes[uti] {
				result.append(contentsOf: exts)
			} else {
				CNLog(type: .Error, message: "Unknown UTI: \(uti)", place: #file)
			}
		}
		return result
	}

	public func UTIs(forExtensions exts: [String]) -> [String] {
		var result: [String] = []
		for ext in exts {
			for uti in mDocumentTypes.keys {
				if let val = mDocumentTypes[uti] {
					if val.contains(ext) {
						result.append(uti)
					}
				}
			}
		}
		return result
	}
}

public class KCLayoutPreference
{
	public var spacing: CGFloat		= 8.0

	public var backgroundColor: KCColor	= KCColor.white

	#if os(iOS)
	public var isPortrait: Bool {
		get {
			return UIApplication.shared.statusBarOrientation.isPortrait
		}
	}
	#endif
}

public class KCTerminalPreference
{
	public var	font:			KCFont
	public var	standardTextColor:	KCColor
	public var	errorTextColor:		KCColor
	public var	backgroundColor:	KCColor

	public init() {
		font			= KCFont(name: "Menlo", size: 12.0)!
		standardTextColor	= KCColor.green
		errorTextColor		= KCColor.red
		backgroundColor		= KCColor.black
	}

	public var cursorAttributes: Dictionary<NSAttributedString.Key, Any> {
		get {
			return [
				.font		: font,
				.foregroundColor: backgroundColor,
				.backgroundColor: standardTextColor
			]
		}
	}

	public var standardAttribute: Dictionary<NSAttributedString.Key, Any> {
		get {
			return [
				.font		: font,
				.foregroundColor: standardTextColor,
				.backgroundColor: backgroundColor
			]
		}
	}

	public var errorAttribute: Dictionary<NSAttributedString.Key, Any> {
		get {
			return [
				.font		: font,
				.foregroundColor: errorTextColor,
				.backgroundColor: backgroundColor
			]
		}
	}
}

