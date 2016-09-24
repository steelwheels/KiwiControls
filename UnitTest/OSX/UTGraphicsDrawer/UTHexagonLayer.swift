/**
 * @file	UTHexagonLayer.swift
 * @brief	Define UTHeagonLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiControls

public class UTHexagonLayer: KCImageLayer
{
	public override func mouseEvent(event evt: KCMouseEvent, at point: CGPoint) -> Bool {
		Swift.print("mouseEvent(\(evt.description), at: \(point.description)")
		return false
	}
}

