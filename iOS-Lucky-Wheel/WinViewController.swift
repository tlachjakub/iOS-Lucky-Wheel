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
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var itemLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	
	
	// Blur effect
	@IBOutlet weak var visualEffectView: UIVisualEffectView!
	var effect:UIVisualEffect!
	
	var item = ""
	var info = ""
	
	
	/////////////////////////////////////////////////////////////////////////////////////////
	// MARK: Inicialization
	/////////////////////////////////////////////////////////////////////////////////////////
	
	class func show(item: String, info: String) {
		if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WinViewController") as? WinViewController {
			controller.item = item
			controller.info = info
			//UIViewController.ruPushOrPresent(controller, animated: true)
			//controller.animateIn()
			
			UIViewController.ruPresent(controller, animated: false)
			//controller.animateIn()
			print("show")
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//print("viewDidLoad winViewController")
		
		itemLabel.text = item
		infoLabel.text = info
		
		// Disable blur effect
		effect = visualEffectView.effect
		visualEffectView.effect = nil
		
		// Add corners to the winView
		winView.layer.cornerRadius = 40
		
		
		// Init
		self.view.alpha = 0
		winView.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
		winView.alpha = 0
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
	
	
	
	
	// Animate pop-up winView
	func animateIn() {
		
		
		//winView.center = self.view.center

		//imageView.alpha = 0
	
		
		
		UIView.animate(withDuration: 0.3, animations: {
			self.view.alpha = 1
		}) { (c) in
			UIView.animate(withDuration: 0.3, animations: {
				
				self.winView.alpha = 1
				//self.imageView.alpha = 1
				self.winView.transform = CGAffineTransform.identity
				
				//print("animateIn")
			})
			
			
		}
		
		
	}
	
	
	
	
	// Animate pop-out winView
	func animateOut() {
		
		UIView.animate(withDuration: 0.5, animations: {
			self.winView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
			self.winView.alpha = 0
			self.view.alpha = 0
			
			//print("animateOut")
		}) { (success:Bool) in
			self.dismiss(animated: false, completion: nil)
		}
	}
	
	
	
	
	// Animate out the winView when "OK" button is pressed
	@IBAction func closeWinView(_ sender: Any) {
		animateOut()
	}
}



