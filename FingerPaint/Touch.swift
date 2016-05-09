//  Touch.swift
//
//  FingerPaint
//
//  Created by Noah Emmet on 4/20/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public enum PointConnection {
	case Curve
	case Line
}

public enum PointNode {
	case End
	indirect case Node(point: CGPoint, next: PointNode, connection: PointConnection)
}

public struct Touch: Hashable {
	
	public var location: CGPoint
	public weak var uiTouch: UITouch?
	public let uuid: String
	public let startTime: NSTimeInterval?
	public init(uiTouch: UITouch) {
		self.location = uiTouch.locationInView(uiTouch.view)
		self.uiTouch = uiTouch
		self.uuid = String(uiTouch)
//		assert(uiTouch.phase == .Began, "UITouch must be .Began")
		if uiTouch.phase == .Began {
			self.startTime = uiTouch.timestamp
		} else {
			self.startTime = nil
		}
	}
	
	public init(location: CGPoint, startTime: NSTimeInterval, uuid: String = NSUUID().UUIDString) {
		self.location = location
		self.startTime = startTime
		self.uuid = uuid
	}
	
	mutating func update() {
		location = uiTouch!.locationInView(uiTouch!.view)
	}
	
	public var hashValue: Int {
		if let uiTouch = uiTouch {
			return uiTouch.hashValue
		} else {
			return uuid.hashValue
		}
	}
}

public func ==(lhs: Touch, rhs: Touch) -> Bool {
	if let lhsUITouch = lhs.uiTouch, let rhsUITouch = rhs.uiTouch {
		return lhsUITouch === rhsUITouch
	} else {
		return lhs.uuid == rhs.uuid
	}
}
