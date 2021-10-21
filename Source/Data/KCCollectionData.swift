/**
 * @file	KCCollectionData.swift
 * @brief Define KCCollectionData class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCCollectionData
{
	public enum CollectionImage {
		case none
		case resource(KCImageResource.ImageType)
		case url(URL)

		public var description: String { get {
			let result: String
			switch self {
			case .none:
				result = "<none>"
			case .resource(let type):
				result = "resource(\(type.name))"
			case .url(let url):
				result = "url(\(url.path)"
			}
			return result
		}}
	}

	private struct CollectionSection {
		var header: String
		var footer: String
		var images: Array<CollectionImage>

		public init(header hdr: String, footer ftr: String, images imgs: Array<CollectionImage>){
			header	= hdr
			footer	= ftr
			images  = imgs
		}
	}

	private var mSections: Array<CollectionSection>

	public init(){
		mSections = []
	}

	public var sectionCount: Int { get { return mSections.count }}

	public func itemCount(inSection sec: Int) -> Int {
		if 0<=sec && sec<mSections.count {
			return mSections[sec].images.count
		} else {
			return 0
		}
	}

	public func sectionHeader(ofSection sec: Int) -> String {
		if 0<=sec && sec<mSections.count {
			return mSections[sec].header
		} else {
			return ""
		}
	}

	public func sectionFooter(ofSection sec: Int) -> String {
		if 0<=sec && sec<mSections.count {
			return mSections[sec].footer
		} else {
			return ""
		}
	}

	public func value(section sec: Int, item itm: Int) -> CollectionImage {
		if 0<=sec && sec<mSections.count {
			let sect = mSections[sec]
			if 0<=itm && itm<sect.images.count {
				return sect.images[itm]
			}
		}
		return .none
	}

	public func add(header hdr: String, footer ftr: String, images imgs: Array<CollectionImage>) {
		let newsect = CollectionSection(header: hdr, footer: ftr, images: imgs)
		mSections.append(newsect)
	}
}

