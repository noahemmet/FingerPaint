//
//  CanvasProtocol.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/20/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public protocol CanvasDelegate: class {
	func touchPathCreated(touchPath: TouchPath)
	func touchPathUpdated(touchPath: TouchPath)
	func touchPathEnded(touchPath: TouchPath)
}

public class CanvasView: UIView {
	public weak var canvasDelegate: CanvasDelegate?
	public var touchPath: TouchPath?
	
	override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		guard let uiTouch = touches.first else {
			return
		}
		let touch = Touch(uiTouch: uiTouch)
		touchPath = TouchPath(initial: touch)
		canvasDelegate?.touchPathCreated(touchPath!)
	}
	
	public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)
		guard let uiTouch = touches.first else {
			return
		}
		let touch = Touch(uiTouch: uiTouch)
		touchPath?.touches.append(touch)
		canvasDelegate?.touchPathUpdated(touchPath!)
	}
	
	public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
		guard let uiTouch = touches.first else {
			return
		}
		let touch = Touch(uiTouch: uiTouch)
		touchPath?.touches.append(touch)
		canvasDelegate?.touchPathEnded(touchPath!)
		touchPath = nil
	}
}