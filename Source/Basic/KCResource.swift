/**
 * @file	KCResource.swift
 * @brief	Define KCResource class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCImageResource
{
	public enum ImageType {
		case characterA
		case chevronBackword
		case chevronForward
		case handRaised
		case paintBrush
		case pencil
		case questionmark

		public var name: String {
			get {
				/* SF symbol name */
				let result: String
				switch self {
				case .characterA:	result = "character-a"
				case .chevronBackword: 	result = "chevron-backward"
				case .chevronForward:	result = "chevron-forward"
				case .handRaised:	result = "hand-raised"
				case .paintBrush:	result = "paintbrush"
				case .pencil:		result = "pencil"
				case .questionmark:	result = "questionmark"
				}
				return result
			}
		}
	}

	public static func URLofImageResource(type itype: ImageType) -> URL {
		if let url = CNFilePath.URLForResourceFile(fileName: itype.name, fileExtension: "png", subdirectory: "Images", forClass: KCImageResource.self) {
			return url
		} else {
			CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			return URL.null()
		}
	}

	public static func imageResource(type itype: ImageType) -> CNImage {
		let url = URLofImageResource(type: itype)
		if let img = CNImage(contentsOf: url) {
			return img
		} else {
			CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			return CNImage()
		}
	}
}

