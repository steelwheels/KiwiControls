/*
 * @file	KCButtonBody.swift
 * @brief	KCButtonBody is class to override drawing functions of NSButton
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import CoconutData
import Cocoa

/**
 * Reference: http://qiita.com/hanamiju/items/ca695aa343a32017ed3f (Japanese)
 */
public class KCButtonBody: NSButton
{
	override public var wantsUpdateLayer: Bool {
		return true
	}

	override public func awakeFromNib() {
		super.awakeFromNib()

		/* Coner of button */
		self.layer?.cornerRadius = 4

		/* Set attribute */
		self.cell?.drawingRect(forBounds: self.bounds)

		/* Do not change the image color when the button is hilighted */
		if let buttonCell = self.cell as? NSButtonCell {
			buttonCell.highlightsBy = NSCell.StyleMask.pushInCellMask
		}
	}
}

