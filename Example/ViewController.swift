//
//  ViewController.swift
//  Example
//
//  Created by Noah Emmet on 4/24/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import UIKit
import FingerPaint

class ViewController: UIViewController {
	
//	var path: UIBezierPath?
	var shapeLayer: CAShapeLayer?
	let colors: [UIColor] = [.purpleColor(), .orangeColor(), .blueColor(), .greenColor(), .redColor()]
	var colorIndex = 0
	var points: [CGPoint] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let paintGestureRecognizer = PaintGestureRecognizer(target: self, action: #selector(ViewController.handlePaint(_:)))
		view.addGestureRecognizer(paintGestureRecognizer)
//		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
//		view.addGestureRecognizer(tapGestureRecognizer)
//		tapGestureRecognizer.cancelsTouchesInView = true
	}
	
	func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
		print("tap")
	}
	
	func handlePaint(paintGestureRecognizer: PaintGestureRecognizer) {
		switch paintGestureRecognizer.state {
		case .Began:
			print("vc touch began")
			let path = UIBezierPath()
			points = []
			switch paintGestureRecognizer.anchorState {
			case .None:
				print("unreachable")
			case .Single(let touch):
				points.append(touch.locationInView(view))
			case .Double(let first, let second):
//				path.moveToPoint(first.locationInView(view))
//				path.moveToPoint(second.locationInView(view))
//				path.addLineToPoint(second.locationInView(view))
				points.append(second.locationInView(view))
			}
			path.moveToPoint(points[0])
			for point in points {
				path.addLineToPoint(point)
			}
			let shapeLayer = CAShapeLayer()
			shapeLayer.path = path.CGPath
			shapeLayer.strokeColor = colors[colorIndex].CGColor
			if 0..<colors.count-1 ~= colorIndex {
				colorIndex += 1
			} else {
				colorIndex = 0
			}
			shapeLayer.fillColor = UIColor.clearColor().CGColor
			shapeLayer.lineWidth = 8
			self.shapeLayer = shapeLayer
			view.layer.addSublayer(shapeLayer)
		case .Changed:
			switch paintGestureRecognizer.anchorState {
			case .None:
				print("unreachable")
			case .Single(let touch):
				points.append(touch.locationInView(view))
			case .Double(let first, let second):
//				path?.addLineToPoint(first.locationInView(view))
				points.removeLast()
				if points.count > 0 {
					points.removeLast()
				}
				points.append(first.locationInView(view))
				points.append(second.locationInView(view))
			}
			let path = UIBezierPath()
			path.moveToPoint(points[0])
			for point in points {
				path.addLineToPoint(point)
			}
			shapeLayer?.path = path.CGPath
		default:
			break
		}
	}
}
