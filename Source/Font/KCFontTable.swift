/**
 * @file	KCFontTable.swift
 * @brief	Define KCFontTable class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoreGraphics

public class KCFontTable
{
	public enum FontStyle {
		case Title
		case Headline
		case Body
		case Caption
	}

	public static let sharedFontTable = KCFontTable()

	private let titleSize:		CGFloat		= 22
	private let headlineSize:	CGFloat		= 16
	private let bodySize:		CGFloat		= 14
	private let captionSize:	CGFloat		= 12

	private init() {

	}

	public func font(withStyle style: FontStyle) -> KCFont {
		#if os(OSX)
			var result: KCFont
			switch style {
			case .Title:	result = KCFont.messageFont(ofSize:	titleSize)
			case .Headline:	result = KCFont.boldSystemFont(ofSize:	headlineSize)
			case .Body:	result = KCFont.messageFont(ofSize:	bodySize)
			case .Caption:	result = KCFont.messageFont(ofSize:	captionSize)
			}
			return result
		#else
			var result: KCFont
			switch style {
			case .Title:	result = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
			case .Headline:	result = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
			case .Caption:	result = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
			case .Body:	result = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
			}
			return result
		#endif
	}
}
