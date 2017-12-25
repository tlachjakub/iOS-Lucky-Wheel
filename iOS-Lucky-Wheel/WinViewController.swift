//
//  WinViewController.swift
//  iOS-Lucky-Wheel
//
//  Created by Jakub Tlach on 12/20/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import Foundation
import UIKit

class WinViewController: UIViewController {
	
	// Views and labels
	@IBOutlet weak var winView: UIView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var iconLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	
	
	// Blur effect
	@IBOutlet weak var visualEffectView: UIVisualEffectView!
	var effect:UIVisualEffect!
	
	var icon = ""
	var name = ""
	
	
	/////////////////////////////////////////////////////////////////////////////////////////
	// MARK: Inicialization
	/////////////////////////////////////////////////////////////////////////////////////////
	
	class func show(icon: String, name: String) {
		if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WinViewController") as? WinViewController {
			controller.icon = icon
			controller.name = name

			UIViewController.ruPresent(controller, animated: false)
			print("show")
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//print("viewDidLoad winViewController")
		
		iconLabel.text = icon
		nameLabel.text = name
		
		// Disable blur effect
		effect = visualEffectView.effect
		visualEffectView.effect = nil
		
		// Add corners to the winView
		winView.layer.cornerRadius = 40
		
		
		// Init
		self.view.alpha = 0
		winView.alpha = 0
		imageView.alpha = 0
		winView.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
		imageView.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
		self.visualEffectView.effect = self.effect
		
		
		// Animate the view controller
		RUTools.runAfter(0.2) {
			self.animateIn()
		}
	}
	
	
	
	
	override func didReceiveMemoryWarning() {
		
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	
	/////////////////////////////////////////////////////////////////////////////////////////
	// MARK: Animation
	/////////////////////////////////////////////////////////////////////////////////////////
	
	// Animate pop-up winView
	func animateIn() {
		
		UIView.animate(withDuration: 0.4, animations: {
			self.winView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
			self.imageView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
			self.winView.alpha = 1
			self.imageView.alpha = 1
			self.view.alpha = 1
		})
	}
	
	
	
	
	// Animate pop-out winView
	func animateOut() {
		
		UIView.animate(withDuration: 0.5, animations: {
			self.winView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
			self.imageView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
			self.winView.alpha = 0
			self.imageView.alpha = 0
			self.view.alpha = 0
			
		}) { (success:Bool) in
			self.dismiss(animated: false, completion: nil)
		}
	}
	
	
	
	
	// Animate out the winView when "OK" button is pressed
	@IBAction func closeWinView(_ sender: Any) {
		animateOut()
	}
}



