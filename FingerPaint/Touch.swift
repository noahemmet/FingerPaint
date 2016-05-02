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
	public init(uiTouch: UITouch) {
		self.location = uiTouch.locationInView(uiTouch.view)
		self.uiTouch = uiTouch
		print(location)
	}
	
	public init(location: CGPoint) {
		self.location = location
	}
	
	public var hashValue: Int {
		return self.uiTouch?.hashValue ?? 0
	}
	
	public func updateLocation() {
		if let uiTouch = uiTouch {
			self.location = uiTouch.locationInView(uiTouch.view)
		}
	}
}

public func ==(lhs: Touch, rhs: Touch) -> Bool {
	return lhs.uiTouch === rhs.uiTouch
}



public enum Anchor {
	case None
	case Single(touch: Touch)
	case Double(first: Touch, second: Touch)
	
	var touches: [Touch] {
		switch self {
		case .None:
			return []
		case .Single(let touch):
			return [touch]
		case .Double(let first, let second):
			return [first, second]
		}
	}
}


public enum TouchAmount {
	case None
	case Single(touch: Touch)
	case Double(first: Touch, second: Touch)
	
	var touches: [Touch] {
		switch self {
		case .None:
			return []
		case .Single(let touch):
			return [touch]
		case .Double(let first, let second):
			return [first, second]
		}
	}
}

public protocol TouchManagerDelegate: class {
	func touchManager(touchManager: TouchManager, didUpdateStroke: Stroke)
}

public class TouchManager {
	
	public var stroke: Stroke = Stroke(points: [])
	public var touches: Set<Touch> = []
	public var state: UIGestureRecognizerState = .Possible
	
	public weak var delegate: TouchManagerDelegate?
	
	public var amount: TouchAmount = .None {
		didSet {
			let fromTo = (from: oldValue, to: amount)
			switch fromTo {
			case (from: .None, to: .None):
//				touches = []
//				fatalError("Beginning from .None to .None is illegal")
				break
			case (from: .None, to: .Single(let newTouch)):
				print("began from .None to .Single")
				state = .Began
				stroke = Stroke(points: [])
//				touches = [newTouch]
//				stroke = Stroke(points: [newTouch.location])
				stroke.points = [newTouch.location]
				
			case (from: .None, to: .Double(let firstNewTouch, let secondNewTouch)):
				print("began from .None to .Double")
				state = .Began
				stroke = Stroke(points: [])
//				touches.insert(firstNewTouch)
//				touches.insert(secondNewTouch)
				let points = [firstNewTouch, secondNewTouch].map { $0.location }
//				stroke = Stroke(touches: touches)
				stroke.points = points
				
			case (from: .Single(let touch), to: .None):
				print("ended from .Single to .None")
				state = .Ended
				self.delegate?.touchManager(self, didUpdateStroke: stroke)
//				touches.remove(touch)
//				stroke.points = []
//				stroke.finishCurrentSegment()
				
			case (from: .Single, to: .Single(let newTouch)):
				print("moved from .Single to .Single")
				print(newTouch.location)
				stroke.points.append(newTouch.location)
				state = .Changed
				// Don't need to update touches; should be the same
				
			case (from: .Single, to: .Double(let firstNewTouch, let secondNewTouch)):
				print("moved from .Single to .Double")
				state = .Changed
//				assert(existingFirstTouch === firstNewTouch, "existingFirstTouch must equal firstNewTouch")
				//				touches.insert(firstNewTouch)
				//				touches.insert(secondNewTouch)
				stroke.temporaryPoints = touches.map { $0.location }
				
			case (from: .Double(let firstTouch, let secondTouch), to: .None):
				print("ended from .Double to .None")
				state = .Ended
//				touches.remove(firstTouch)
//				touches.remove(secondTouch)
				stroke.temporaryPoints = []
				stroke.points.appendContentsOf(touches.map { $0.location })
				self.delegate?.touchManager(self, didUpdateStroke: stroke)
				
			case (from: .Double(let oldFirstTouch, let oldSecondTouch), to: .Single(let newFirstTouch)):
				print("changed from .Double to .Single")
				state = .Changed
//				touches.remove(oldFirstTouch)
//				touches.remove(oldSecondTouch)
//				touches.insert(newFirstTouch)
				stroke.points.appendContentsOf(stroke.temporaryPoints)
				stroke.temporaryPoints = []
				
			case (from: .Double(_, _), to: .Double(let firstTouch, let secondTouch)):
				print("moved from .Double to .Double")
				state = .Changed
				let points = [firstTouch, secondTouch].map { $0.location }
				stroke.temporaryPoints = points
			}
//			self.delegate?.touchManager(self, didUpdateStroke: stroke)
		}
	}
	
	public func setTouches() {
		for touch in self.touches {
			touch.updateLocation()
		}
		
		let touches = Array(self.touches)
		switch touches.count {
		case 0:
			self.amount = .None
		case 1:
			self.amount = .Single(touch: touches[0])
		case 2:
			self.amount = .Double(first: touches[0], second: touches[1])
		default:
			print("Not handling >2 touches at this time")
		}
	}
	
	public func setUITouches(uiTouches: Set<UITouch>) {
//		self.setTouches(Set(uiTouches.map { Touch(uiTouch: $0) }))
		self.setTouches()
	}
}