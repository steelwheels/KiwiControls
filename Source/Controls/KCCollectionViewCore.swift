/**
 * @file KCCollectionViewCore.swift
 * @brief Define KCCollectionViewCore class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData
import Foundation

#if os(OSX)
private typealias KCCollectionViewBase 		 = NSCollectionView
private typealias KCCollectionViewDataSourceBase = NSCollectionViewDataSource
private typealias KCCollectionViewDelegateBase	 = NSCollectionViewDelegate
#else
private typealias KCCollectionViewBase 		 = UICollectionView
private typealias KCCollectionViewDataSourceBase = UICollectionViewDataSource
private typealias KCCollectionViewDelegateBase	 = UICollectionViewDelegate
#endif

open class KCCollectionViewCore: KCCoreView
{
	#if os(OSX)
	@IBOutlet weak var osxCollectionView: NSCollectionView!
	#else
	@IBOutlet weak var iosCollectionView: UICollectionView!
	#endif

	private var mDataSource =   KCCollectionViewDataSource()

	private var collectionView: KCCollectionViewBase {
		get {
			#if os(OSX)
				return osxCollectionView
			#else
				return iosCollectionView
			#endif
		}
	}

	public func setup(frame frm: CGRect) -> Void {
		let colview = collectionView
		super.setup(isSingleView: true, coreView: colview)
		KCView.setAutolayoutMode(views: [self, colview])
		collectionView.dataSource = mDataSource
	}

	public func store(dataInterface intf: CNCollectionInterface){
		NSLog("store new interface")
		mDataSource.dataInterface = intf
		collectionView.reloadData()
		self.invalidateIntrinsicContentSize()
		self.requireLayout()
	}

	public var numberOfSections: Int { get {
		if let intf = mDataSource.dataInterface {
			NSLog("numberOfSections -> \(intf.sectionCount)")
			return intf.sectionCount
		} else {
			NSLog("numberOfSections -> nil")
			return 0
		}
	}}
}

private class KCCollectionViewDataSource: NSObject, KCCollectionViewDataSourceBase
{
	static let ResuseIdentifier = "value"

	public var dataInterface: CNCollectionInterface? = nil

	public override init(){
	}

	public func numberOfSections(in collectionView: KCCollectionViewBase) -> Int {
		if let intf = dataInterface {
			return intf.sectionCount
		} else {
			return 0
		}
	}

	public func collectionView(_ collectionView: KCCollectionViewBase, numberOfItemsInSection section: Int) -> Int {
		if let intf = dataInterface {
			NSLog("numberOfItemsInSection(\(section)) -> \(intf.sectionCount)")
			return intf.sectionCount
		} else {
			NSLog("numberOfItemsInSection(\(section)) -> nil")
			return 0
		}
	}

	#if os(OSX)
	public func collectionView(_ collectionView: KCCollectionViewBase, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let value: CNValue
		if let intf = dataInterface {
			value = intf.value(section: indexPath.section, item: indexPath.item)
		} else {
			value = .nullValue
		}
		NSLog("value of item -> \(value.toText().toStrings().joined(separator: "\n"))")
		let view   = KCCollectionViewItem()
		view.value = value
		return view
	}
	#else
	public func collectionView(_ collectionView: KCCollectionViewBase, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KCCollectionViewDataSource.ResuseIdentifier, for: indexPath)
		return cell
	}
	#endif
}

private class KCCollectionViewDelegate: NSObject, KCCollectionViewDelegateBase
{
}

#if os(OSX)
private class KCCollectionViewItem: NSCollectionViewItem
{
	private var mValue:      CNValue = .nullValue
	private var mDidUpdated: Bool	 = false

	public var value: CNValue {
		get		{ return mValue }
		set(newval)	{
			mValue = newval
			mDidUpdated = true
		}
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
	}

	public override func loadView() {
		guard mDidUpdated else {
			return
		}
		let newview   = KCValueView()
		newview.value = mValue
		self.view     = newview
		mDidUpdated   = false
	}
}
#endif



