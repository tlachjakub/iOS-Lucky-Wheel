//
//  ViewController.swift
//  iOS-Lucky-Wheel
//
//  Created by Jakub Tlach on 12/11/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	// Views and labels
	@IBOutlet weak var imageView: UIImageView!
	
	
	// Coordinates and angels
	var startImageAngle: CGFloat = 0.0
	var startTouchAngle: CGFloat = 0.0
	var moveTouchAngle: CGFloat = 0.0
	var lastAngle: CGFloat = 0.0
	//var winIndex: Int = 0
	var winPrize: Prize? = nil
	
	
	
	// Data
	let prizes = [
		Prize(index: 0, name: "1x Present", icon: "🎁", angle: 0.0, count: 0, maxCount: 10, probability: 100),
		Prize(index: 1, name: "¥100", icon: "💴", angle: (2*CGFloat.pi/12), count: 0, maxCount: 5, probability: 50),
		Prize(index: 2, name: "You LOSE", icon: "💀", angle: (2*CGFloat.pi/12)*2, count: 0, maxCount: 1, probability: 250),
		Prize(index: 3, name: "1x Candy", icon: "🍭", angle: (2*CGFloat.pi/12)*3, count: 0, maxCount: 25, probability: 300),
		Prize(index: 4, name: "-5%", icon: "🏷", angle: (2*CGFloat.pi/12)*4, count: 0, maxCount: 10, probability: 100),
		Prize(index: 5, name: "¥1000", icon: "💴", angle: (2*CGFloat.pi/12)*5, count: 0, maxCount: 5, probability: 50),
		Prize(index: 6, name: "You LOSE", icon: "💀", angle: (2*CGFloat.pi/12)*6, count: 0, maxCount: 1, probability: 250),
		Prize(index: 7, name: "1x Present", icon: "🎁", angle: (2*CGFloat.pi/12)*7, count: 0, maxCount: 10, probability: 100),
		Prize(index: 8, name: "1x Decoration", icon: "🎄", angle: (2*CGFloat.pi/12)*8, count: 0, maxCount: 15, probability: 250),
		Prize(index: 9, name: "¥500", icon: "💴", angle: (2*CGFloat.pi/12)*9, count: 0, maxCount: 5, probability: 50),
		Prize(index: 10, name: "You LOSE", icon: "💀", angle: (2*CGFloat.pi/12)*10, count: 0, maxCount: 1, probability: 250),
		Prize(index: 11, name: "1x Donut", icon: "🍩", angle: (2*CGFloat.pi/12)*11, count: 0, maxCount: 25, probability: 300)
	]
	

	
	
	/////////////////////////////////////////////////////////////////////////////////////////
	// MARK: Inicialization
	/////////////////////////////////////////////////////////////////////////////////////////
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	
	/////////////////////////////////////////////////////////////////////////////////////////
	// MARK: Touches
	/////////////////////////////////////////////////////////////////////////////////////////
	
	// Position, where the touch started on the screen
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		
		totalDelta = 0
		
		
		if let touch = touches.first {
			
			// Check the every element
			winPrize = getWinPrize()
			print("Prize number: \(winPrize?.index ?? 0)")
			
			// Current Touch Angle
			let position = touch.preciseLocation(in: self.view)
			let center = imageView.center
			startTouchAngle = center.angleRadPositiveToPoint(position)
			
			
			// Current Image Angle
			startImageAngle = CGFloat(atan2f(Float(imageView.transform.b), Float(imageView.transform.a)))
			moveTouchAngle = startTouchAngle
		}
	}
	
	var totalDelta: CGFloat = 0
	
	
	// Move with wheel while moving with finger on the screen
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touch = touches.first {
			
			// Current Touch Angle
			let position = touch.preciseLocation(in: self.view)
			let center = imageView.center
			let newAngle = center.angleRadPositiveToPoint(position)
			
			let delta = newAngle - moveTouchAngle
			moveTouchAngle = newAngle
			
			totalDelta += delta
			
			print("totalDelta: \(totalDelta)")
			
			//print("Current angle: \(moveTouchAngle)")
			rotateAngle(angle: startImageAngle + (moveTouchAngle - startTouchAngle))
		}
	}
	
	
	
	
	// Position, where the touch ended on the screen
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		// If there is no move, do not rotate the wheel
		if moveTouchAngle == 0 {
			return
		}
		
		
		if let touch = touches.first {
			
			// Current Touch Angle
			let position = touch.preciseLocation(in: self.view)
			let center = imageView.center
			let newAngle = center.angleRadPositiveToPoint(position)
			
			
			let direction: CGFloat = totalDelta >= 0 ? 1 : -1
			//let direction: CGFloat = 1
			print("direction: \(direction)    totalDelta = \(totalDelta)")
			
			guard let prize = winPrize else { print("ERROR: No Prize"); return }
			
			print("Start angle: \(newAngle)")
			// Set rotation
			let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
			rotateAnimation.isRemovedOnCompletion = false
			rotateAnimation.fillMode = kCAFillModeForwards
			rotateAnimation.fromValue = newAngle
			rotateAnimation.toValue = prize.angle + 6 * CGFloat.pi //* direction
			print("End angle: \(prize.angle + 6 * CGFloat.pi)")
			
			//rotateAnimation.duration = min(max(Double(delta * 10), 4), 8)
			rotateAnimation.duration = 4
			rotateAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.0, 0.5, 0.1, 1)
			rotateAnimation.delegate = self
			self.imageView.layer.add(rotateAnimation, forKey: nil)
		}
	}
	
	
	
	
	// Probability
	func getWinPrize() -> Prize {

		// Free Items
		var newPrizes: [Prize] = []
		for item in prizes {
			if item.count < item.maxCount {
				newPrizes.append(item)
			}
		}

		
		print("----------------------------------------")
		print("Possible prizes: \(newPrizes.count)")

		
		// Total
		var total = 0
		for item in newPrizes {
			total += item.probability
		}
		print("Total probability: \(total)")

		
		// Random
		let prob = Int(arc4random_uniform(UInt32(total))+1)
		print("Random number: \(prob)")

		
		// Choose Prize
		var count = 0
		for item in newPrizes {
			count += item.probability

			// Found Win Prize
			if prob <= count {
				if item.icon != "💀" {
					item.count += 1
				}
				return item
			}
		}

		
		// Didn't find Prize, Lose
		return prizes[2]
	}
	
	
	
	
	// Rotate by angle
	func rotateAngle(angle: CGFloat) {
		self.imageView.transform = CGAffineTransform(rotationAngle: angle)
	}
}




/////////////////////////////////////////////////////////////////////////////////////////
// MARK: CAAnimationDelegate extension
/////////////////////////////////////////////////////////////////////////////////////////

extension ViewController: CAAnimationDelegate {
	
	func animationDidStart(_ anim: CAAnimation) {
		
		// Stop the user interaction when the wheel is moving
		self.view.isUserInteractionEnabled = false
	}
	
	
	
	
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		
		// Prize
		guard let prize = winPrize else { return }


		// Start the user interaction after the wheel stops
		self.view.isUserInteractionEnabled = true
		

		// Wait and activate animation again
		RUTools.runAfter(0.1) {

			
			// Reset View
			RUTools.instantTransaction {
				self.imageView.layer.removeAllAnimations()
				self.rotateAngle(angle: CGFloat(prize.angle))
			}
			
			
			// Open next WinViewController
			WinViewController.show(icon: prize.icon, name: prize.name)
		}
	}
}
