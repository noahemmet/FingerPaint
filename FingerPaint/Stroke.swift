//
//  Paint.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/28/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public class Stroke {
	public var points: [CGPoint] = []
	public var temporaryPoints: [CGPoint] = []
	
	public var color: UIColor?
	
	public init(points: [CGPoint]) {
		self.points = points
	}
	
	public init(point: CGPoint) {
		self.points = [point]
	}
	
	public init(touches: [Touch]) {
		self.points = touches.map { $0.location }
	}
	
	public init(touchPath: TouchPath) {
		
	}
	
	public var bezierPath: UIBezierPath {
		let path = UIBezierPath()
		if points.count > 0 {
			path.moveToPoint(points[0])
			for point in points.dropFirst(1) {
				path.addLineToPoint(point)
			}
		} else {
//			print("no points")
		}
		return path
	}
}


extension Stroke {
	public func createLayer(scale scale: CGFloat = 1) -> CAShapeLayer {
		let shapeLayer = CAShapeLayer()
		var affineTransform = CGAffineTransformMakeScale(scale, scale)
		let transformedPath = CGPathCreateCopyByTransformingPath(bezierPath.CGPath, &affineTransform)
		shapeLayer.path = transformedPath
		shapeLayer.fillColor = UIColor.clearColor().CGColor
		shapeLayer.strokeColor = color?.CGColor ?? UIColor.blackColor().CGColor
		shapeLayer.lineWidth = 8 * scale
		return shapeLayer
	}
}