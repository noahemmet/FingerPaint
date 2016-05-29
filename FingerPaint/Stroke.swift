//
//  Paint.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/28/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public class Stroke {
	public let path: UIBezierPath
	
	public var color: UIColor?
	
	public init(points: [CGPoint], closed: Bool = false) {
		self.path = UIBezierPath(catmullRomPoints: points, closed: closed, alpha: 0.5)
	}
	
	public init(touches: [Touch], closed: Bool = false) {
		let points = touches.map { $0.location }
		self.path = UIBezierPath(catmullRomPoints: points, closed: closed, alpha: 0.5)
	}
	
	public init?(touchPath: TouchPath) {
		return nil
	}
}


extension Stroke {
	public func createLayer(scale scale: CGFloat = 1) -> CAShapeLayer {
		let shapeLayer = CAShapeLayer()
		var affineTransform = CGAffineTransformMakeScale(scale, scale)
		let transformedPath = CGPathCreateCopyByTransformingPath(path.CGPath, &affineTransform)
		shapeLayer.path = transformedPath
		shapeLayer.fillColor = UIColor.clearColor().CGColor
		shapeLayer.strokeColor = color?.CGColor ?? UIColor.blackColor().CGColor
		shapeLayer.lineWidth = 8 * scale
		
		return shapeLayer
	}
}