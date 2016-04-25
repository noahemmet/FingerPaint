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
	
	@IBOutlet var canvasView: CanvasView!
	var path: UIBezierPath?
	var shapeLayer: CAShapeLayer?
	let colors: [UIColor] = [.purpleColor(), .orangeColor(), .blueColor(), .greenColor(), .redColor()]
	var colorIndex = 0
	override func viewDidLoad() {
		super.viewDidLoad()
//		canvasView.canvasDelegate = self
		let paintGestureRecognizer = PaintGestureRecognizer(target: self, action: #selector(ViewController.touched(_:)))
		view.addGestureRecognizer(paintGestureRecognizer)
		
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func touched(paintGestureRecognizer: PaintGestureRecognizer) {
		switch paintGestureRecognizer.state {
		case .Began:
			print("vc touch began")
			let path = UIBezierPath()
			switch paintGestureRecognizer.anchorState {
			case .None:
				print("unreachable")
			case .Single(let touch):
				path.moveToPoint(touch.locationInView(view))
				path.addLineToPoint(touch.locationInView(view))
			case .Double(let first, let second):
//				path.moveToPoint(first.locationInView(view))
//				path.moveToPoint(second.locationInView(view))
				path.addLineToPoint(second.locationInView(view))
			}
			self.path = path
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
			print("vc touch changed")
			switch paintGestureRecognizer.anchorState {
			case .None:
				print("unreachable")
			case .Single(let touch):
				path?.addLineToPoint(touch.locationInView(view))
			case .Double(let first, let second):
//				path?.addLineToPoint(first.locationInView(view))
				path?.addLineToPoint(second.locationInView(view))
			}
			shapeLayer?.path = path?.CGPath
		default:
			break
		}
	}
}


extension ViewController {
//	func touchPathCreated(touchPath: TouchPath) {
//		print("created", touchPath)
//	}
//	
//	func touchPathUpdated(touchPath: TouchPath) {
//		print("updated", touchPath)
//	}
//	
//	func touchPathEnded(touchPath: TouchPath) {
//		print("ended", touchPath)
//	}
}