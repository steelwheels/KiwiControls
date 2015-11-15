/**
 * @file	KCSingleWindowSegue.h
 * @brief	Define KCSingleWindowSegue class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa

public class KCSingleWindowSegue : NSStoryboardSegue
{
	/* Referece : http://stackoverflow.com/questions/28454291/transitioning-between-view-controller-os-x */
	public override func perform() {
		if let fromViewController = sourceController as? NSViewController {
			if let toViewController = destinationController as? NSViewController {
				fromViewController.view.window?.contentViewController = toViewController
			}
		}
	}

}

