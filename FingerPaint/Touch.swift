//  Touch.swift
//
//  FingerPaint
//
//  Created by Noah Emmet on 4/20/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public class Touch: Hashable {
	
	public var location: CGPoint
	public weak var uiTouch: UITouch?
	public let uuid: String
	public init(uiTouch: UITouch) {
		self.location = uiTouch.locationInView(uiTouch.view)
		self.uiTouch = uiTouch
		self.uuid = String(uiTouch) 
	}
	
	public init(location: CGPoint) {
		self.location = location
		self.uuid = NSUUID().UUIDString
	}
	
	public var hashValue: Int {
		if let uiTouch = uiTouch {
			return uiTouch.hashValue
		} else {
			return uuid.hashValue
		}
	}
	
	public func updateLocation() {
		if let uiTouch = uiTouch {
			self.location = uiTouch.locationInView(uiTouch.view)
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

public protocol TouchManagerDelegate: class {
	func touchManager(touchManager: TouchManager, didUpdateStroke: Stroke)
}

public class TouchManager {
	
	public private(set) var stroke: Stroke = Stroke(points: [])
	public private(set) var touches: Set<Touch> = [] {
		didSet {
			// update location?
			for touch in touches {
				touch.updateLocation()
			}
			let newLocations = touches.map { $0.location }
			let diffTouches = Array(oldValue.exclusiveOr(touches))
			let diffCount = (from: oldValue.count, to: touches.count)
			switch diffCount {
			case (from: 0, to: 0):
				fatalError("Beginning from .None to .None is illegal")
				break
			case (from: 0, to: 1):
				print("began from .None to .Single")
				state = .Began
				let newTouch = diffTouches[0]
				stroke = Stroke(point: newTouch.location)
				
			case (from: 0, to: 2):
				print("began from .None to .Double")
				state = .Began
				stroke = Stroke(points: newLocations)
//				stroke.temporaryPoints = points
				
			case (from: 1, to: 0):
				print("ended from .Single to .None")
				state = .Ended
				
			case (from: 1, to: 1):
//				print("moved from .Single to .Single")
				state = .Changed
				stroke.points.append(newLocations[0])
				// Don't need to update touches; should be the same
				
			case (from: 1, to: 2):
				print("changed from .Single to .Double")
				state = .Changed
				let newTouch = diffTouches[0]
				stroke.points.append(newTouch.location)
				
			case (from: 2, to: 0):
				print("ended from .Double to .None")
				state = .Ended
//				stroke.points = 
				
			case (from: 2, to: 1):
				print("changed from .Double to .Single")
				state = .Changed
//				stroke.points.appendContentsOf(oldValue.map { $0.location })
				
			case (from: 2, to: 2):
				//				print("moved from .Double to .Double")
				state = .Changed
				stroke.points.removeLast(2)
				stroke.points.appendContentsOf(newLocations)
			default:
				print("Not handling >2 touches")
//				fatalError("Not handling >2 touches")
			}
		}
	}
	public private(set) var state: UIGestureRecognizerState = .Possible
	
	public weak var delegate: TouchManagerDelegate?
	
	public func removeTouches(touches: Set<Touch>) {
		for touch in touches {
			self.touches.remove(touch)
		}
	}
	
	public func addTouches(touches: Set<Touch>) {
		for touch in touches {
			touch.updateLocation()
		}
		self.touches.unionInPlace(touches)
	}
	
	public func removeUITouches(uiTouches: Set<UITouch>) {
		self.removeTouches(Set(uiTouches.map { Touch(uiTouch: $0) }))
	}
	
	public func addUITouches(uiTouches: Set<UITouch>) {
		self.addTouches(Set(uiTouches.map { Touch(uiTouch: $0) }))
	}
}