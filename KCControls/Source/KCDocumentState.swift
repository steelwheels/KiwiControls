/*
 * @file	KCDocumentState.h
 * @brief	Define KCDocumentState class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class KCDocumentState : KCState
{
	public var mName	: String?
	public var mIsDirty	: Bool
	
	public init(isDirty dirty: Bool){
		mName    = nil
		mIsDirty = dirty
	}
	
	public var isDirty: Bool {
		get { return mIsDirty }
	}
}

