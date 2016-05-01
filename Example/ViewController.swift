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
	
	var shapeLayers: [CAShapeLayer] = []
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
		return
		switch paintGestureRecognizer.state {
		case .Began:
			print("vc touch began")
			let path = UIBezierPath()
			points = []
			switch paintGestureRecognizer.anchor {
			case .None:
				print("unreachable")
			case .Single(let touch):
				points.append(touch.location)
			case .Double(_, let second):
				points.append(second.location)
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
			shapeLayers.append(shapeLayer)
			view.layer.addSublayer(shapeLayer)
		case .Changed:
			switch paintGestureRecognizer.anchor {
			case .None:
				print("unreachable")
			case .Single(let touch):
				points.append(touch.location)
			case .Double(let first, let second):
				points.removeLast()
				if points.count > 0 {
					points.removeLast()
				}
				points.append(first.location)
				points.append(second.location)
			}
			let path = UIBezierPath()
			path.moveToPoint(points[0])
			for point in points {
				path.addLineToPoint(point)
			}
			shapeLayers.last?.path = path.CGPath
			
		case .Ended:
			for shape in shapeLayers {
				shape.opacity -= 0.1
				if shape.opacity <= 0 {
					shape.removeFromSuperlayer()
				}
			}
		default:
			break
		}
	}
}
