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
	public init(uiTouch: UITouch) {
		self.location = uiTouch.locationInView(uiTouch.view)
		self.uiTouch = uiTouch
		self.uuid = String(uiTouch) 
	}
	
	public init(location: CGPoint, uuid: String = NSUUID().UUIDString) {
		self.location = location
		self.uuid = uuid
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

public protocol TouchManagerDelegate: class {
	func touchManager(touchManager: TouchManager, didUpdateStroke: Stroke)
}

public class TouchManager {
	
	public private(set) var stroke: Stroke = Stroke(points: [])
	public private(set) var anchors: [Touch] = []
	public private(set) var touchNodes: [Set<Touch>] = [] 
	//	public private(set) var touches: Set<Touch> = [] 
	public private(set) var state: UIGestureRecognizerState = .Possible
	
	public weak var delegate: TouchManagerDelegate?
	
	
	private func updateTouchNodes(previous previous: Set<Touch>, next: Set<Touch>) {
		
		// update location?
//		for touch in touchNodes.flatten() {
//			touch.updateLocation()
//		}
		let previousTouches = previous
		let newTouches = next
		let diffTouches = newTouches.exclusiveOr(previousTouches)
		let diffCount = (from: previousTouches.count, to: newTouches.count)
		switch diffCount {
		case (from: 0, to: 0):
			fatalError("Beginning from .None to .None is illegal")
			
		case (from: 0, to: 1):
			print("began from .None to .Single")
			state = .Began
			let newTouch = newTouches.first!
			touchNodes = [next]
//			anchors = Array(next)
			
		case (from: 0, to: 2):
			print("began from .None to .Double")
			state = .Began
			touchNodes = [next]
			anchors = Array(next)
			
		case (from: 1, to: 0):
			print("ended from .Single to .None")
			state = .Ended
			touchNodes = []
			anchors = []
			
		case (from: 1, to: 1):
//			print("moved from .Single to .Single")
			state = .Changed
			let newTouch = newTouches.first!
			let newLocation = newTouch.location
			if anchors.count == 1 {
				if anchors[0] == newTouch {
					print("matched anchor1 0")
					touchNodes.append(next)
				}
			} else {
				touchNodes.append(next)
			}
			
		case (from: 1, to: 2):
			print("changed from .Single to .Double")
			state = .Changed
			touchNodes.append(next)
			anchors = Array(diffTouches)
			
		case (from: 2, to: 0):
			print("ended from .Double to .None")
			state = .Ended 
			//				anchors = []
			touchNodes = []
			
		case (from: 2, to: 1):
			print("changed from .Double to .Single")
			state = .Changed
			touchNodes.append(next)
			
		case (from: 2, to: 2):
			//				print("moved from .Double to .Double")
			state = .Changed
			touchNodes.removeLast()
			touchNodes.append(next)
			
			
		default:
			print("Not handling >2 touches")
			//				fatalError("Not handling >2 touches")
		}
	}
	
	public var bezierPath: UIBezierPath {
		let bezierPath = UIBezierPath()
		bezierPath.moveToPoint(touchNodes.first!.first!.location)
		for touchNode in touchNodes {
			for touch in touchNode {
				bezierPath.addLineToPoint(touch.location)
			}
		}
		return bezierPath
	}
	
	public func removeTouches(removedTouches: Set<Touch>) {
		if var nextTouches = touchNodes.last {
			for touch in removedTouches {
				nextTouches.remove(touch)
			}
			updateTouchNodes(previous: touchNodes.last!, next: nextTouches)
			//			lastTouches.unionInPlace(removedTouches)
//			touchNodes.append(nextTouches)
		} else {
			print("impossiblé!")
		}
	}
	
	public func addTouches(addedTouches: Set<Touch>) {
		//		for touch in touches {
		//			touch.updateLocation()
		//		}
		//		self.touches.unionInPlace(touches)
		if var nextTouches = touchNodes.last {
			nextTouches.unionInPlace(addedTouches)
			updateTouchNodes(previous: touchNodes.last!, next: nextTouches)
//			touchNodes.append(lastTouches)
		} else {
			updateTouchNodes(previous: [], next: addedTouches)
		}
	}
	
	public func removeUITouches(uiTouches: Set<UITouch>) {
		self.removeTouches(Set(uiTouches.map { Touch(uiTouch: $0) }))
	}
	
	public func addUITouches(uiTouches: Set<UITouch>) {
		self.addTouches(Set(uiTouches.map { Touch(uiTouch: $0) }))
	}
}