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
	
	var result = ""
	
	
	let prizes = [
		Prize(name: "Present", icon: "🎁"),
		Prize(name: "Present", icon: "🎁"),
		Prize(name: "Present", icon: "🎁")
	]
	
	
	// Arrays
	let info = ["Present", "¥100", "You LOSE", "Candy", "-5%", "¥1000", "You LOSE",
				"Present", "Decoration", "¥500", "You LOSE", "Donut", "All OUT"]
	
	let item = ["🎁", "💴", "💀", "🍭", "🏷", "💴", "💀",
				"🎁", "🎄", "💴", "💀", "🍩", "✘"]
	
	let angle:[CGFloat] = [0.0, (2*CGFloat.pi/12), (2*CGFloat.pi/12)*2, (2*CGFloat.pi/12)*3, (2*CGFloat.pi/12)*4,
						   (2*CGFloat.pi/12)*5, (2*CGFloat.pi/12)*6, (2*CGFloat.pi/12)*7, (2*CGFloat.pi/12)*8,
						   (2*CGFloat.pi/12)*9, (2*CGFloat.pi/12)*10, (2*CGFloat.pi/12)*11, 0.0]
	
	var currentCount:[Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	let maxCount:[Int] = [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	/////////////////////////////////////////////////////////////////////////////////////////
	// MARK: Inicialization
	/////////////////////////////////////////////////////////////////////////////////////////
	
	override func viewDidLoad() {
		
		//prizes[0].name
		
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
			checkTimer()
			
			
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
			rotateAnimation.toValue = angle[winIndex]
			currentCount[winIndex] += 1
			rotateAnimation.duration = min(max(Double(delta * 10), 4), 8)
			rotateAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.0, 0.5, 0.3, 1)
			rotateAnimation.delegate = self
			
			self.imageView.layer.add(rotateAnimation, forKey: nil)
			
			print("timer winIndex: \(currentCount[winIndex])")
			//print("delta: \(delta * 100)")

		}
	}
	
	
	
	
	// Check for random value
	func checkTimer() {
		if checkTimerAll() == false {
			winIndex = 12
			print("\(winIndex) out")
		} else {
			repeat {
				winIndex = Int(arc4random_uniform(12))
				print("\(winIndex) repeat")
			}
				while currentCount[winIndex] == maxCount[winIndex]
		}
		print("\(winIndex) final")
	}
	
	
	
	
	// Check condition for all elements
	func checkTimerAll() -> Bool {
		
		// Loop the whole array and compare with max values of timer
		var counter = 0
		for number in currentCount {
			if currentCount[number] == maxCount[number] {
				counter = counter + 1
			} else {
				return true
			}
		}
		
		// If all elements are OUT return false
		if counter == currentCount.count {
			return false
		}
		return true
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
		
		UIView.setAnimationsEnabled(false)
		
		// Start the user interaction after the wheel stops
		self.view.isUserInteractionEnabled = true
		
		// Rotate the angle
		rotateAngle(angle: CGFloat(angle[winIndex]))
		
		
		RUTools.runAfter(0.01) {
			UIView.setAnimationsEnabled(true)

			// Open next WinViewController
			WinViewController.show(item: self.item[self.winIndex], info: self.info[self.winIndex])
		}
	}
	

}
