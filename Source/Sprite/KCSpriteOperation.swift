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
	public typealias UpdateHandler = (_ interval: TimeInterval, _ status: KCSpriteNodeStatus, _ radar: KCSpriteRadar, _ action: KCSpriteNodeAction) -> KCSpriteNodeAction?

	public static let 	NameItem	= "name"
	public static let 	IntervalItem	= "interval"
	public static let 	StatusItem	= "status"
	public static let 	RadarItem	= "radar"
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

	public class func setInterval(context ctxt: CNOperationContext, interval difftime: TimeInterval){
		let num = NSNumber(floatLiteral: Double(difftime))
		ctxt.setParameter(name: IntervalItem, value: .numberValue(num))
	}

	public class func getInterval(context ctxt: CNOperationContext) -> TimeInterval? {
		if let val = ctxt.parameter(name: IntervalItem) {
			if let num = val.toNumber() {
				return TimeInterval(num.doubleValue)
			}
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

	public class func setRadar(context ctxt: CNOperationContext, radar rad: KCSpriteRadar){
		ctxt.setParameter(name: RadarItem, value: rad.toValue())
	}

	public class func getRadar(context ctxt: CNOperationContext) -> KCSpriteRadar? {
		if let val = ctxt.parameter(name: RadarItem) {
			return KCSpriteRadar.spriteRadar(from: val)
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

	public class func execute(context ctxt: CNOperationContext, updateFunction updfunc: KCSpriteOperationContext.UpdateHandler) -> Bool {
		var result = false
		if let interval = KCSpriteOperationContext.getInterval(context: ctxt),
		   let curstat  = KCSpriteOperationContext.getStatus(context: ctxt),
		   let currad   = KCSpriteOperationContext.getRadar(context: ctxt),
		   let curact   = KCSpriteOperationContext.getAction(context: ctxt) {
			if let newact = updfunc(interval, curstat, currad, curact) {
				KCSpriteOperationContext.setResult(context: ctxt, action: newact)
				result = true
			}
		}
		return result
	}
}


