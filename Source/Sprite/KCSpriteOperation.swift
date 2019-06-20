/**
 * @file KCSpriteOperation.swift
 * @brief Define KCSpriteOperation class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSpriteOperationContext
{
	public static let 	NameItem	= "name"
	public static let 	StatusItem	= "status"
	public static let	ActionItem	= "action"
	public static let 	ResultItem	= "result"

	public class func setName(context ctxt: CNOperationContext, name nm: String){
		ctxt.setParameter(name: NameItem, value: .stringValue(nm))
	}

	public class func getName(context ctxt: CNOperationContext) -> String? {
		if let val = ctxt.parameter(name: NameItem) {
			return val.toString()
		}
		return nil
	}

	public class func setStatus(context ctxt: CNOperationContext, status stat: KCSpriteNodeStatus){
		ctxt.setParameter(name: StatusItem, value: stat.toValue())
	}

	public class func getStatus(context ctxt: CNOperationContext) -> KCSpriteNodeStatus? {
		if let val = ctxt.parameter(name: StatusItem) {
			return KCSpriteNodeStatus.spriteNodeStatus(from: val)
		}
		return nil
	}

	public class func setAction(context ctxt: CNOperationContext, action act: KCSpriteNodeAction){
		ctxt.setParameter(name: ActionItem, value: act.toValue())
	}

	public class func getAction(context ctxt: CNOperationContext) -> KCSpriteNodeAction? {
		if let val = ctxt.parameter(name: ActionItem) {
			return KCSpriteNodeAction.spriteNodeAction(from: val)
		}
		return nil
	}

	public class func setResult(context ctxt: CNOperationContext, action act: KCSpriteNodeAction){
		ctxt.setParameter(name: ResultItem, value: act.toValue())
	}

	public class func getResult(context ctxt: CNOperationContext) -> KCSpriteNodeAction? {
		if let val = ctxt.parameter(name: ResultItem) {
			return KCSpriteNodeAction.spriteNodeAction(from: val)
		}
		return nil
	}
}


