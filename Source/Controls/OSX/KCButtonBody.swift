/*
 * @file	KCButtonBody.swift
 * @brief	KCButtonBody is class to override drawing functions of NSButton
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Cocoa

/**
 * Reference: http://qiita.com/hanamiju/items/ca695aa343a32017ed3f (Japanese)
 */
public class KCButtonBody: NSButton
{
	private var mColors		: KCColorPreference.ButtonColors? = nil

	public var colors: KCColorPreference.ButtonColors? {
		get {
			return mColors
		}
		set(newcolor){
			mColors = newcolor
			updateColor()
		}
	}

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

	override public func updateLayer() {
		if let cols = mColors {
			let backcolor	: KCColor
			if self.cell!.isHighlighted {
				backcolor = cols.background.highlight
			} else {
				backcolor = cols.background.normal
			}
			self.layer?.backgroundColor = backcolor.cgColor
		}
	}

	private func updateColor(){
		if let cols = mColors  {
			let colorAttributeTitle = NSMutableAttributedString(attributedString: self.attributedTitle)
			let range = NSMakeRange(0, colorAttributeTitle.length)
			colorAttributeTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: cols.title, range: range)
			self.attributedTitle = colorAttributeTitle
		}
	}
}

