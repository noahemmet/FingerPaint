//
//  PaintGestureRecognizer.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/24/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

public class PaintGestureRecognizer: UIGestureRecognizer {
	
	public enum AnchorState {
		case None
		case Single(touch: UITouch)
		case Double(first: UITouch, second: UITouch)
	}
	
	public enum PaintPhase {
		case AnchoredLine
		case UnanchoredLine
		case Draw
	}
	
	public var anchorState: AnchorState = .None
	var paintPhase: PaintPhase?
	var firstAnchor: UITouch?
	var secondAnchor: UITouch?
	
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesBegan(touches, withEvent: event)
		let allTouches = Array(touches)
		switch allTouches.count {
		case 1:
			switch anchorState {
			case .None:
				print("1 began from .None to .Single")
				anchorState = .Single(touch: allTouches[0])
				state = .Began
			case .Single(let touch):
				print("1 began from .Single to .Double")
				anchorState = .Double(first: touch, second: allTouches[0])
			case .Double(_, _):
				print("1 began from .Double to .None (failed)")
				anchorState = .None
				state = .Failed
			}
		case 2:
			switch anchorState {
			case .None:
				print("2 began from .None to .Double")
				anchorState = .Double(first: allTouches[0], second: allTouches[1])
				state = .Began
			case .Single(_), .Double(_, _):
				print("2 began from .Single/Double to .None (failed)")
				anchorState = .None
				state = .Failed
			}
		default:
			print("default began (failed)")
			state = .Failed
		}
	}
	
	override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesMoved(touches, withEvent: event)
		state = .Changed
	}
	
	override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesEnded(touches, withEvent: event)
		switch touches.count {
		case 1:
			switch anchorState {
			case .None:
				print("1 ended from .None (failed)")
				state = .Failed
			case .Single(_):
				print("1 ended from .Single to .None")
				anchorState = .None
				state = .Ended
			case .Double(_, let secondTouch):
				print("1 ended from .Double to .Single")
				anchorState = .Single(touch: secondTouch)
			}
		case 2:
			switch anchorState {
			case .None:
				print("2 ended from .None (failed)")
				state = .Failed
			case .Single(_):
				print("2 ended .Single (failed)")
				anchorState = .None
				state = .Failed
			case .Double(_, let secondTouch):
				print("2 ended from .Double to .Single")
				anchorState = .Single(touch: secondTouch)
			}
		default:
			print("default ended (failed)")
			break
		}
		
	}
}