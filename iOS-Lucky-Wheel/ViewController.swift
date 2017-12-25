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
	var startImageAngle:CGFloat = 0.0
	var startTouchAngle:CGFloat = 0.0
	var moveTouchAngle:CGFloat = 0.0
	var lastAngle:CGFloat = 0.0
	var winIndex: Int = 0
	
	
	// Data
	let prizes = [
		Prize(name: "Present", icon: "🎁", angle: 0.0, count: 0, maxCount: 1, probability: 10),
		Prize(name: "¥100", icon: "💴", angle: (2*CGFloat.pi/12), count: 0, maxCount: 1, probability: 10),
		Prize(name: "You LOSE", icon: "💀", angle: (2*CGFloat.pi/12)*2, count: 0, maxCount: 0, probability: 10),
		Prize(name: "Candy", icon: "🍭", angle: (2*CGFloat.pi/12)*3, count: 0, maxCount: 0, probability: 10),
		Prize(name: "-5%", icon: "🏷", angle: (2*CGFloat.pi/12)*4, count: 0, maxCount: 0, probability: 10),
		Prize(name: "¥1000", icon: "💴", angle: (2*CGFloat.pi/12)*5, count: 0, maxCount: 0, probability: 10),
		Prize(name: "You LOSE", icon: "💀", angle: (2*CGFloat.pi/12)*6, count: 0, maxCount: 0, probability: 10),
		Prize(name: "Present", icon: "🎁", angle: (2*CGFloat.pi/12)*7, count: 0, maxCount: 0, probability: 10),
		Prize(name: "Decoration", icon: "🎄", angle: (2*CGFloat.pi/12)*8, count: 0, maxCount: 0, probability: 10),
		Prize(name: "¥500", icon: "💴", angle: (2*CGFloat.pi/12)*9, count: 0, maxCount: 0, probability: 10),
		Prize(name: "You LOSE", icon: "💀", angle: (2*CGFloat.pi/12)*10, count: 0, maxCount: 0, probability: 10),
		Prize(name: "Donut", icon: "🍩", angle: (2*CGFloat.pi/12)*11, count: 0, maxCount: 0, probability: 10),
		Prize(name: "All OUT", icon: "✘", angle: 0.0, count: 0, maxCount: 0, probability: 10)
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
		
		if let touch = touches.first {
			
			// Check the every element
			checkCount()
			
			
			// Current Touch Angle
			let position = touch.preciseLocation(in: self.view)
			let center = imageView.center
			startTouchAngle = center.angleRadPositiveToPoint(position)
			
			
			// Current Image Angle
			startImageAngle = CGFloat(atan2f(Float(imageView.transform.b), Float(imageView.transform.a)))
			moveTouchAngle = 0.0
		}
	}
	
	
	
	
	// Move with wheel while moving with finger on the screen
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touch = touches.first {
			
			// Current Touch Angle
			let position = touch.preciseLocation(in: self.view)
			let center = imageView.center
			moveTouchAngle = center.angleRadPositiveToPoint(position)
			
			
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
			let lastTouchAngle = center.angleRadPositiveToPoint(position)
			
			
			let delta = lastTouchAngle - moveTouchAngle
			let start = startImageAngle + (moveTouchAngle - startTouchAngle)
			lastAngle = start + delta
			
			
			let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
			rotateAnimation.fromValue = start
			
			//if delta < 0 { rotateAnimation.toValue = angle[winIndex] * -1 }
			rotateAnimation.toValue = prizes[winIndex].angle
			rotateAnimation.duration = min(max(Double(delta * 10), 4), 8)
			rotateAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.0, 0.5, 0.3, 1)
			rotateAnimation.delegate = self
			
			self.imageView.layer.add(rotateAnimation, forKey: nil)
			
			if winIndex == 2 || winIndex == 6 || winIndex == 10 {
				print("LOSE")
			} else {
				prizes[winIndex].count += 1
			}
			
			print("timer winIndex: \(prizes[winIndex].count)")
			//print("delta: \(delta * 100)")

		}
	}
	
	
	
	
	// Check for random value
	func checkCount() {
		if checkCountOfAll() == false {
			winIndex = 12
			print("\(winIndex) out")
		} else {
			repeat {
				winIndex = Int(arc4random_uniform(12))
				print("\(winIndex) repeat")
			}
				while prizes[winIndex].count == prizes[winIndex].maxCount
		}
		print("\(winIndex) final")
	}
	
	
	
	
	// Check condition for all elements
	func checkCountOfAll() -> Bool {
		
		// Loop the whole array and compare with max values of timer
		var counter = 0
		for item in prizes {
			if item.count == item.maxCount {
				counter += 1
			} else {
				return true
			}
		}
		
		
		// If all elements are OUT return false
		if counter != prizes.count {
			return true
		} else {
			return false
		}
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
		
		// Deactivate animation
		UIView.setAnimationsEnabled(false)
		
		
		// Start the user interaction after the wheel stops
		self.view.isUserInteractionEnabled = true
		
		
		// Rotate the angle
		rotateAngle(angle: CGFloat(prizes[winIndex].angle))
		
		
		// Wait and activate animation again
		RUTools.runAfter(0.01) {
			UIView.setAnimationsEnabled(true)

			// Open next WinViewController
			WinViewController.show(icon: self.prizes[self.winIndex].icon, name: self.prizes[self.winIndex].name)
		}
	}
	

}
