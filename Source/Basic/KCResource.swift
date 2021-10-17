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
		case arrowLeft
		case arrowRight
		case brush
		case pen
	}

	public static func URLofImageResource(type itype: ImageType) -> URL {
		let filename: String
		switch itype {
		case .characterA:	filename = "char-a"
		case .arrowLeft: 	filename = "arrow-left"
		case .arrowRight:	filename = "arrow-right"
		case .brush:		filename = "brush"
		case .pen:		filename = "pen"
		}
		if let url = CNFilePath.URLForResourceFile(fileName: filename, fileExtension: "png", subdirectory: "Images", forClass: KCImageResource.self) {
			return url
		} else {
			CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			return URL.null()
		}
	}

	public static func imageResource(type itype: ImageType) -> CNImage? {
		let url = URLofImageResource(type: itype)
		if let img = CNImage(contentsOf: url) {
			return img
		} else {
			CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			return nil
		}
	}
}

