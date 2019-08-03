/**
 * @file KCSpriteRadar.swift
 * @brief Define KCSpriteRadat class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSpriteRadar: CNNativeStruct
{
	private static let NodePositionsItem		= "nodePositions"

	public struct NodePosition {
		public var name:	String
		public var teamId:	Int
		public var position:	CGPoint

		public init(name nm: String, teamId tid:Int, position pos: CGPoint) {
			name 	 = nm
			teamId	 = tid
			position = pos
		}

		public func toValue() -> CNNativeValue {
			let props: Dictionary<String, CNNativeValue> = [
				"name":		CNNativeValue.stringValue(name),
				"teamId":	CNNativeValue.numberValue(NSNumber(integerLiteral: teamId)),
				"position":	CNNativeValue.pointValue(position)
			]
			return CNNativeValue.dictionaryValue(props)
		}
	}

	private var mNodePositions:	Array<NodePosition> 	// <<node-name, node-info>

	public init(){
		mNodePositions = []
		super.init(name: "SpriteRadar")

		let empty = CNNativeValue.arrayValue([])
		super.setMember(name: KCSpriteRadar.NodePositionsItem, value: empty)
	}

	public func setPositions(positions newpos: Array<NodePosition>) {
		mNodePositions = newpos
		/* Update node info */
		var posval: Array<CNNativeValue> = []
		for pos in newpos {
			posval.append(pos.toValue())
		}
		let newval = CNNativeValue.arrayValue(posval)
		super.setMember(name: KCSpriteRadar.NodePositionsItem, value: newval)
	}

	public class func spriteRadar(from val: CNNativeValue) -> KCSpriteRadar? {
		if let arr = val.arrayProperty(identifier: KCSpriteRadar.NodePositionsItem) {
			let newradar = KCSpriteRadar()
			var newpos: Array<NodePosition> = []
			for elm in arr {
				if let pos = KCSpriteRadar.decodeNodePosition(value: elm) {
					newpos.append(pos)
				} else {
					NSLog("Failed to decode element")
				}
			}
			newradar.setPositions(positions: newpos)
			return newradar
		}
		return nil
	}

	private class func decodeNodePosition(value val: CNNativeValue) -> NodePosition? {
		if let nameval = val.stringProperty(identifier: "name"),
		   let idval   = val.numberProperty(identifier: "teamId"),
		   let posval  = val.pointProperty(identifier: "position") {
			return NodePosition(name: nameval, teamId: idval.intValue, position: posval)
		} else {
			return nil
		}
	}
}



