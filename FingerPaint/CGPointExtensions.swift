//
//  CGPointExtensions.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/4/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public extension CGPoint {
	public func distanceTo(point otherPoint: CGPoint) -> CGFloat {
		let distance = hypotf(Float(otherPoint.x - x), Float(otherPoint.y - y))
		return CGFloat(distance)
	}
}