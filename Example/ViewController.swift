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
	
	
	@IBOutlet weak var canvasView: UIView!
	
	@IBOutlet weak var historyView: HistoryView!
	
	var shapeLayers: [CAShapeLayer] = []
	var shapeLayer: CAShapeLayer = CAShapeLayer()
	let colors: [UIColor] = [.purpleColor(), .orangeColor(), .blueColor(), .greenColor(), .redColor()]
	var colorIndex = 0
	var points: [CGPoint] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let paintGestureRecognizer = PaintGestureRecognizer(target: self, action: #selector(ViewController.handlePaint(_:)))
		paintGestureRecognizer.delegate = self
		canvasView.addGestureRecognizer(paintGestureRecognizer)
		canvasView.layer.addSublayer(shapeLayer)
		
		let history = History()
		historyView.history = history
		historyView.history.delegate = historyView
		historyView.historyViewDelegate = self
//		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
//		view.addGestureRecognizer(tapGestureRecognizer)
//		tapGestureRecognizer.cancelsTouchesInView = true
	}
	
	func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
		print("tap")
	}
	
	func handlePaint(paintGestureRecognizer: PaintGestureRecognizer) {
//		shapeLayer = CAShapeLayer()
		
//		shapeLayer.path = paintGestureRecognizer.touchManager.stroke.bezierPath.CGPath
//		shapeLayer.strokeColor = colors[colorIndex].CGColor
//		shapeLayer.fillColor = UIColor.clearColor().CGColor
//		shapeLayer.lineWidth = 8
////		shapeLayers.append(shapeLayer)
////		view.layer.addSublayer(shapeLayer)
//		
//		if paintGestureRecognizer.state == .Ended {
//			shapeLayers.append(shapeLayer)
////			shapeLayer = CAShapeLayer()
////			view.layer.addSublayer(shapeLayer)
//			
//			if 0..<colors.count-1 ~= colorIndex {
//				colorIndex += 1
//			} else {
//				colorIndex = 0
//			}
//		}
//		return
		
		switch paintGestureRecognizer.state {
		case .Began:
			let shapeLayer = CAShapeLayer()
			shapeLayer.path = paintGestureRecognizer.touchManager.stroke.bezierPath.CGPath
			shapeLayer.strokeColor = colors[colorIndex].CGColor
			if 0..<colors.count-1 ~= colorIndex {
				colorIndex += 1
			} else {
				colorIndex = 0
			}
			shapeLayer.fillColor = UIColor.clearColor().CGColor
			shapeLayer.lineWidth = 8
			shapeLayers.append(shapeLayer)
			canvasView.layer.addSublayer(shapeLayer)
		case .Changed:
			shapeLayers.last?.path = paintGestureRecognizer.touchManager.stroke.bezierPath.CGPath
			
		case .Ended:
			historyView.history.appendStroke(paintGestureRecognizer.touchManager.stroke)
			for shape in shapeLayers {
//				shape.opacity -= 0.1
//				if shape.opacity <= 0 {
//					shape.removeFromSuperlayer()
//				}
			}
		default:
			break
		}
	}
}


extension ViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		
		
		if (touch.view != self.canvasView) { // accept only touchs on superview, not accept touchs on subviews
			return false
		}
		return true

	}
}

extension ViewController: HistoryViewDelegate {
	func resetToStroke(stroke: Stroke, atIndex index: Int) {
		for layerIndex in index..<shapeLayers.count {
			let layer = shapeLayers[layerIndex]
			layer.removeFromSuperlayer()
		}
		shapeLayers.removeLast(shapeLayers.count - index)
	}
}