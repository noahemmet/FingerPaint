//
//  PaintGestureRecognizer.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/24/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

public protocol PaintGestureDelegate {
	func paintGestureRecognizer(paintGestureRecognizer: PaintGestureRecognizer, didUpdateTouchPath: TouchPath)
}

public class PaintGestureRecognizer: UIGestureRecognizer {
	
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
	
	public var anchor: Anchor = .None
	public var paintDelegate: PaintGestureDelegate?
	private var touchPath: TouchPath!
	
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesBegan(touches, withEvent: event)
		// TODO: Make sure touches are always the same order.
		let allTouches = Array(touches).map { Touch(uiTouch: $0) }
		switch allTouches.count {
		case 1:
			switch anchor {
			case .None:
				print("1 began from .None to .Single")
				anchor = .Single(touch: allTouches[0])
				state = .Began
			case .Single(let touch):
				print("1 began from .Single to .Double")
				anchor = .Double(first: touch, second: allTouches[0])
			case .Double(_, _):
				print("1 began from .Double to .None (failed)")
				anchor = .None
				state = .Failed
			}
		case 2:
			switch anchor {
			case .None:
				print("2 began from .None to .Double")
				anchor = .Double(first: allTouches[0], second: allTouches[1])
				state = .Began
			case .Single(_), .Double(_, _):
				print("2 began from .Single/Double to .None (failed)")
				anchor = .None
				state = .Failed
			}
		default:
			print("default began (failed)")
			state = .Failed
		}
		touchPath = TouchPath(initial: anchor.touches)
		paintDelegate?.paintGestureRecognizer(self, didUpdateTouchPath: touchPath)
	}
	
	override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesMoved(touches, withEvent: event)
		state = .Changed
		let allTouches = Array(touches).map { Touch(uiTouch: $0) }
		switch allTouches.count {
		case 1:
			anchor = .Single(touch: allTouches[0])
		case 2:
			anchor = .Double(first: allTouches[0], second: allTouches[1])
		default:
			print("default began (failed)")
			state = .Failed
		}
		touchPath.addTouches(anchor.touches)
		paintDelegate?.paintGestureRecognizer(self, didUpdateTouchPath: touchPath)

	}
	
	override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesEnded(touches, withEvent: event)
		switch touches.count {
		case 1:
			switch anchor {
			case .None:
				print("1 ended from .None (failed)")
				state = .Failed
			case .Single(_):
				print("1 ended from .Single to .None")
				anchor = .None
				state = .Ended
			case .Double(_, let secondTouch):
				print("1 ended from .Double to .Single")
				anchor = .Single(touch: secondTouch)
			}
		case 2:
			switch anchor {
			case .None:
				print("2 ended from .None (failed)")
				state = .Failed
			case .Single(_):
				print("2 ended .Single (failed)")
				anchor = .None
				state = .Failed
			case .Double(_, let secondTouch):
				print("2 ended from .Double to .Single")
				anchor = .Single(touch: secondTouch)
			}
		default:
			print("default ended (failed)")
			break
		}
		
		touchPath.addTouches(anchor.touches)
		paintDelegate?.paintGestureRecognizer(self, didUpdateTouchPath: touchPath)
		if touchPath.history.last?.isEmpty == true {
			touchPath = nil
		}
	}
	
	public override func shouldRequireFailureOfGestureRecognizer(otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return otherGestureRecognizer is UITapGestureRecognizer
	}
}