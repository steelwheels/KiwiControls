/**
 * @file KCSpriteRadar.swift
 * @brief Define KCSpriteRadat class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSpriteRadar
{
	public struct NodeInfo {
		var name:	String
		var teamId:	Int
		var position:	CGPoint

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

		public static func nodeInfo(from value: CNNativeValue) -> NodeInfo? {
			if let name   = value.stringProperty(identifier: "name"),
			   let teamid = value.numberProperty(identifier: "teamId"),
			   let pos    = value.pointProperty(identifier:  "position") {
				return NodeInfo(name: name, teamId: teamid.intValue, position: pos)
			} else {
				return nil
			}
		}
	}

	private var mNodeInfo:	Array<NodeInfo>

	public init(){
		mNodeInfo = []
	}

	public func append(nodeInfo ninfo: NodeInfo){
		mNodeInfo.append(ninfo)
	}

	public func toValue() -> CNNativeValue {
		var topvalues: Array<CNNativeValue> = []
		for ninfo in mNodeInfo {
			topvalues.append(ninfo.toValue())
		}
		return CNNativeValue.arrayValue(topvalues)
	}

	public static func spriteRadar(from value: CNNativeValue) -> KCSpriteRadar? {
		if let topvals = value.toArray() {
			let newradar = KCSpriteRadar()
			for topval in topvals {
				if let ninfo = NodeInfo.nodeInfo(from: topval) {
					newradar.append(nodeInfo: ninfo)
				}
			}
			return newradar
		}
		return nil
	}
}

