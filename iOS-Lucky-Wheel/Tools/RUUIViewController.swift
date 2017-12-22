//
//  RUUIViewController.swift
//  SwiftFramework
//
//  Created by Sergio Santos on 2017/01/10.
//  Copyright (c) 2017 RiseUP. All rights reserved.
//

import UIKit

extension UIViewController {


	/// System's Root ViewController (the bottom ViewController)
	///
	static var ruRootViewController: UIViewController {
		return UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
	}
	
	/// Top Presented ViewController
	///	Use this to present a view on top of everything
	///
	static var ruPresentedViewController: UIViewController {
        return UIApplication.shared.keyWindow?.rootViewController?.ruPresentedViewController ?? UIViewController()
    }

	static var ruVisibleViewController: UIViewController {
		return UIApplication.shared.keyWindow?.rootViewController?.ruVisibleViewController ?? ruPresentedViewController
	}
	
	
	
	
	
	///	Use this to push a ViewController on the top Navigation Controller,
	/// if there is no Navigation controller it will Present on top of everything
	///
	static func ruPushOrPresent(_ controller: UIViewController, animated: Bool = true, completion: (()->())? = nil) {
		UIViewController.ruVisibleViewController.ruPushOrPresent(controller, animated: animated, completion: completion)
	}

	///	Use this to preset a ViewController on top of everything
	///
	static func ruPresent(_ controller: UIViewController, animated: Bool = true, completion: (()->())? = nil) {
		UIViewController.ruPresentedViewController.present(controller, animated: animated, completion: completion)
	}
	
	
	


	
	
	
	
	
	///////////////////////////////////////////////////////////////////////////////////////
	// MARK: Instance Methods
	///////////////////////////////////////////////////////////////////////////////////////
	
	var ruPresentedViewController: UIViewController {
		if let vc = self.presentedViewController {
			return vc.ruPresentedViewController
		} else {
			return self
		}
	}

	var ruVisibleViewController: UIViewController {
		
        if let nav = self as? UINavigationController {
            if let visible = nav.visibleViewController {
                return visible.ruVisibleViewController
            }
        }
        
        if let tab = self as? UITabBarController {
            if let selected = tab.selectedViewController {
                return selected.ruVisibleViewController
            }
        }
        
		if let vc = self.presentedViewController {
			return vc.ruVisibleViewController
		} else {
			return self
		}
	}
	
	func ruPushOrPresent(_ controller: UIViewController, animated: Bool = true, completion: (()->())? = nil) {
		
		// Aux
		let top = ruVisibleViewController
		
		// Push
		if let nav = top.navigationController {
			nav.pushViewController(controller, animated: animated)
			if let comp = completion {
				RUTools.runAfter(0.5) {
					comp()
				}
			}
			return
		}

		// Present
		top.present(controller, animated: animated, completion: completion)
	}
	
	func ruPopOrDismiss(animated: Bool = true, completion: (()->())? = nil) {
		
		// In in a Navigation Controller?
		if let nav = navigationController {
			
			// Is the root view? -> Dismiss the Navigation Conroller
			if let first = nav.viewControllers.first {
				if first == self {
					nav.dismiss(animated: animated, completion: completion)
					return
				}
			}
			
			// Is top view?
			if nav.visibleViewController == self {
				if completion != nil {
					CATransaction.begin()
					CATransaction.setCompletionBlock(completion)
					nav.popViewController(animated: animated)
					CATransaction.commit()
				} else {
					nav.popViewController(animated: animated)
				}
				return
			}
			
			// Just remove
			nav.ruRemoveFromNavigationController()
			return
		}
		
		// Just dismiss
		dismiss(animated: animated, completion: completion)
	}
	
	
	func ruRemoveLeftSpaceFromNavigationBar() {
		
		// iPads don't have navigation bar
		if RUTools.isiPad {
			return
		}

		
		var items = navigationItem.leftBarButtonItems
		let negative = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
		negative.width = -16.0
		items?.insert(negative, at: 0)
		navigationItem.setLeftBarButtonItems(items, animated: false)
		
		// Right Side
//		var rightItems = navigationItem.rightBarButtonItems
//		rightItems?.append(negative)
//		navigationItem.setRightBarButtonItems(rightItems, animated: false)
	}
	
	func ruRemoveFromNavigationController() {
		self.navigationController?.viewControllers = (self.navigationController?.viewControllers.filter({$0 as UIViewController != self}))!
	}
	
}

















