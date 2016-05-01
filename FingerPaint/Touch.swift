//
//  Touch.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/20/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public class Touch {
	
	public let location: CGPoint
	
	public init(uiTouch: UITouch) {
		self.location = uiTouch.locationInView(uiTouch.view)
		print(location)
	}
	
	public init(location: CGPoint) {
		self.location = location
	}
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


public enum TouchPhase {
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

protocol TouchManagerProtocol {
	
}

public class TouchManager {
	
	var stroke: Stroke!
	var touches: [Touch] = []
	
	public var phase: TouchPhase = .None {
		didSet {
			let fromTo = (from: oldValue, to: phase)
			switch fromTo {
			case (from: .None, to: .None):
				touches = []
				fatalError("Beginning from .None to .None is illegal")
				
			case (from: .None, to: .Single(let newTouch)):
				print("began from .None to .Single")
				touches = [newTouch]
				
				let freeSegment = Segment.Free(points: [newTouch.location])
				stroke = Stroke(segment: freeSegment)
				
				
			case (from: .None, to: .Double(let firstNewTouch, let secondNewTouch)):
				print("began from .None to .Double")
				touches = [firstNewTouch, secondNewTouch]
				
				let lineSegment = Segment.Line(pointOne: firstNewTouch.location, pointTwo: secondNewTouch.location)
				stroke = Stroke(segment: lineSegment)
				
			case (from: .Single, to: .None):
				print("ended from .Single to .None")
				touches = []
//				stroke.finishCurrentSegment()
				
			case (from: .Single, to: .Single):
				print("moved from .Single to .Single")
				// Don't need to update touches; should be the same
				
				switch stroke.currentSegment! {
				case .Free(let points):
					stroke.currentSegment.po
				default:
					fatalError("Single to Single must be Segment.Free")
				}
				
			case (from: .Single(let existingFirstTouch), to: .Double(let firstNewTouch, let secondNewTouch)):
//				assert(existingFirstTouch === firstNewTouch, "existingFirstTouch must equal firstNewTouch")
				touches = [firstNewTouch, secondNewTouch]
				
			case (from: .Double(_, _), to: .None):
				print("ended from .Double to .None")
				touches = []
				
			case (from: .Double(_, _), to: .Single(let newFirstTouch)):
				print("ended from .Double to .Single")
				touches = [newFirstTouch]
				
			case (from: .Double(_, _), to: .Double(_, _)):
				print("moved from .Double to .Double")
				
			default:
				print(touches)
				fatalError("how'd we get to default?")
				break
			}
		}
	}
	
	public func setUITouches(uiTouches: [UITouch]) {
		let touches: [Touch] = uiTouches.filter { touch in
			return touch.phase != .Ended
			}.map { Touch(uiTouch: $0) }
		switch touches.count {
		case 0:
			self.phase = .None
		case 1:
			self.phase = .Single(touch: touches[0])
		case 2:
			self.phase = .Double(first: touches[0], second: touches[1])
		default:
			print("Not handling >2 touches at this time")
		}
	}
	
}