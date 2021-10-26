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
public  typealias KCCollectionViewBase 		 = NSCollectionView
private typealias KCCollectionViewDataSourceBase = NSCollectionViewDataSource
private typealias KCCollectionViewDelegateBase	 = NSCollectionViewDelegateFlowLayout
private typealias KCCollectionViewLayout	 = NSCollectionViewFlowLayout
#else
public  typealias KCCollectionViewBase 		 = UICollectionView
private typealias KCCollectionViewDataSourceBase = UICollectionViewDataSource
private typealias KCCollectionViewDelegateBase	 = UICollectionViewDelegate
private typealias KCCollectionViewLayout	 = UICollectionViewFlowLayout
#endif

#if os(OSX)
private let ItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "valueItem")
#else
private let ItemIdentifier = "ImageCell"
#endif

open class KCCollectionViewCore: KCCoreView, KCCollectionViewDataSourceBase, KCCollectionViewDelegateBase
{
	public typealias SelectedCallback = (_ section: Int, _ item: Int) -> Void

	static let ResuseIdentifier = "value"

	#if os(OSX)
	@IBOutlet weak var osxCollectionView: NSCollectionView!
	#else
	@IBOutlet weak var iosCollectionView: UICollectionView!
	#endif

	private var mCollectionData		 = CNCollection()
	private var mNumberOfRows		 = 2
	private var mLoadedItemNum		 = 0
	private var mMaxItemSize		 = KCSize.zero
	private var mTotalItemNum		 = 0
	private var mCallback: SelectedCallback? = nil

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
		colview.dataSource = self
		colview.delegate   = self

		#if os(OSX)
			let bdl = Bundle(for: KCCollectionViewCore.self)
			let nib = NSNib(nibNamed: "KCCollectionViewItem", bundle: bdl)
			colview.register(nib, forItemWithIdentifier: ItemIdentifier)
		#else
			let bdl = Bundle(for: KCCollectionViewCore.self)
			let nib = UINib(nibName: "KCCollectionViewCell", bundle: bdl)
			colview.register(nib, forCellWithReuseIdentifier: ItemIdentifier)
		#endif
	}

	public func store(data dat: CNCollection){
		mCollectionData = dat
		mLoadedItemNum  = 0
		mTotalItemNum   = dat.totalCount()
		collectionView.reloadData()
		self.select(section: 0, item: 0)
		self.invalidateIntrinsicContentSize()
		self.requireLayout()
	}

	public var numberOfSections: Int { get {
		return mCollectionData.sectionCount
	}}

	public func numberOfItems(inSection sec: Int) -> Int? {
		return mCollectionData.itemCount(inSection: sec)
	}

	public var numberOfRows: Int {
		get	    { return mNumberOfRows 	}
		set(newnum) { mNumberOfRows = newnum 	}
	}

	public var isSelectable: Bool {
		get {
			#if os(OSX)
				return collectionView.isSelectable
			#else
				return collectionView.allowsSelection
			#endif
		}
		set(newval) {
			#if os(OSX)
				collectionView.isSelectable            = newval
				collectionView.allowsEmptySelection    = false
				collectionView.allowsMultipleSelection = false
			#else
				collectionView.allowsSelection         = newval
				collectionView.allowsMultipleSelection = false
			#endif
		}
	}

	public var selectedItems: Set<IndexPath> {
		get {
			#if os(OSX)
				return collectionView.selectionIndexPaths
			#else
				if let arr = collectionView.indexPathsForSelectedItems {
					return Set(arr)
				} else {
					return Set()
				}
			#endif
		}
	}

	public var itemSize: KCSize {
		get {
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewLayout {
				return layout.itemSize
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (0-0)", atFunction: #function, inFile: #file)
				return KCSize(width: -1.0, height: -1.0)
			}
		}
		set(newsize){
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewLayout {
				layout.itemSize = newsize
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (0-1)", atFunction: #function, inFile: #file)
			}
		}
	}

	public var minimumLineSpacing: CGFloat {
		get {
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewLayout {
				return layout.minimumLineSpacing
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (1-0)", atFunction: #function, inFile: #file)
				return 0.0
			}
		}
		set(newval){
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewLayout {
				layout.minimumLineSpacing = newval
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (1-1)", atFunction: #function, inFile: #file)
			}
		}
	}

	public var minimumInteritemSpacing: CGFloat {
		get {
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewLayout {
				return layout.minimumInteritemSpacing
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (2-0)", atFunction: #function, inFile: #file)
				return 0.0
			}
		}
		set(newval){
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewLayout {
				layout.minimumInteritemSpacing = newval
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (2-1)", atFunction: #function, inFile: #file)
			}
		}
	}

	public override var intrinsicContentSize: KCSize {
		get {
			let rownum = mNumberOfRows
			let colnum = (mTotalItemNum + mNumberOfRows - 1) / mNumberOfRows
			var width  = mMaxItemSize.width  * CGFloat(rownum)
			if colnum > 1 {
				width  += CGFloat(colnum - 1) * self.minimumInteritemSpacing
			}
			var height = mMaxItemSize.height * CGFloat(colnum)
			if rownum > 1 {
				height += CGFloat(rownum - 1) * self.minimumLineSpacing
			}
			let result = KCSize(width: width, height: height)
			NSLog("intrinsicContentSize: \(result.description)")
			return result
		}
	}

	public func select(section sec: Int, item itm: Int) {
		let path = IndexPath(item: itm, section: sec)
		#if os(OSX)
		if let item = collectionView.item(at: path) {
			item.isSelected = true
		} else {
			CNLog(logLevel: .error, message: "Invalid index (\(sec), \(itm))", atFunction: #function, inFile: #file)
		}
		#else
		if let cell = collectionView.cellForItem(at: path) {
			cell.isSelected = true
		} else {
			CNLog(logLevel: .error, message: "Invalid index (\(sec), \(itm))", atFunction: #function, inFile: #file)
		}
		#endif
	}

	public func set(callback cbfunc: @escaping SelectedCallback) {
		mCallback = cbfunc
	}

	public var firstResponderView: KCViewBase? { get {
		return collectionView
	}}

	/*
	 * Data source methods
	 */
	public func numberOfSections(in collectionView: KCCollectionViewBase) -> Int {
		return mCollectionData.sectionCount
	}

	public func collectionView(_ collectionView: KCCollectionViewBase, numberOfItemsInSection section: Int) -> Int {
		return mCollectionData.itemCount(inSection: section)
	}

	#if os(OSX)
	public func collectionView(_ collectionView: KCCollectionViewBase, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let view = collectionView.makeItem(withIdentifier: ItemIdentifier, for: indexPath)
		var didset = false
		if let item = mCollectionData.value(section: indexPath.section, item: indexPath.item) {
			if let v = view as? KCCollectionViewItem {
				let img      = allocateImage(type: item)
				v.image      = img
				mMaxItemSize = KCMaxSize(sizeA: mMaxItemSize, sizeB: img.size)
				didset = true
			} else {
				CNLog(logLevel: .error, message: "Unexpected item type: \(view.description)", atFunction: #function, inFile: #file)
			}
		}
		NSLog("item: \(indexPath.section) \(indexPath.item) -> \(mLoadedItemNum) \(mMaxItemSize.description)")
		if didset {
			mLoadedItemNum += 1
			if mLoadedItemNum == mTotalItemNum {
				NSLog("notify to update")
				self.itemSize = mMaxItemSize
				self.invalidateIntrinsicContentSize()
				self.requireLayout()
				self.notify(viewControlEvent: .updateSize(self))
			}
		} else {
			CNLog(logLevel: .error, message: "Failed to set image: \(indexPath.description)", atFunction: #function, inFile: #file)
		}
		return view
	}
	#else
	public func collectionView(_ collectionView: KCCollectionViewBase, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KCCollectionViewCore.ResuseIdentifier, for: indexPath)
		return cell
	}
	#endif

	private func allocateImage(type typ: CNCollection.Item) -> CNImage {
		var result: CNImage
		switch typ {
		case .image(let url):
			if let img = CNImage(contentsOf: url){
				result = img
			} else {
				CNLog(logLevel: .error, message: "Failed to load image", atFunction: #function, inFile: #file)
				result = CNImage()
			}
		@unknown default:
			CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			result = CNImage()
		}
		return result
	}

	/*
	 * Delegate
	 */
	#if os(OSX)
	public func collectionView(_ collectionView: KCCollectionViewBase, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
		return indexPaths
	}
	#else
	public func collectionView(_ collectionView: KCCollectionViewBase, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	#endif

	#if os(OSX)
	public func collectionView(_ collectionView: KCCollectionViewBase, didSelectItemsAt indexPaths: Set<IndexPath>) {
		if let path = indexPaths.first {
			didSelect(itemAt: path)
		}
	}
	#else
	public func collectionView(_ collectionView: KCCollectionViewBase, didSelectItemAt indexPath: IndexPath) {
		didSelect(itemAt: indexPath)
	}
	#endif

	private func didSelect(itemAt indexPath: IndexPath){
		if let cbfunc = mCallback {
			cbfunc(indexPath.section, indexPath.item)
		}
	}
}



