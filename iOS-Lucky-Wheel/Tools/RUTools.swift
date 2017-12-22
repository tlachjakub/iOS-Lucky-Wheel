//
//  RUTools.swift
//  SwiftFramework
//
//  Created by Sergio Santos on 2017/01/10.
//  Copyright (c) 2017 RiseUP. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics




/////////////////////////////////////////////////////////////////////
// MARK:   DEBUG
/////////////////////////////////////////////////////////////////////

func ruPrint(_ string: String) {
	#if DEBUG
		print(string)
	#endif
}







////////////////////////////////////////////////////////////////////////////
// MARK: - Tools
////////////////////////////////////////////////////////////////////////////

class RUTools {
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Paths
	////////////////////////////////////////////////////////////////////////////
	
	static var mDocumentsURL : URL? = nil
	class var documentsURL: URL {
		if mDocumentsURL == nil {
			let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			mDocumentsURL = urls[urls.endIndex-1]
		}
		return mDocumentsURL!
	}
	class var documentsPath: String {
		return RUTools.documentsURL.path
	}
	
	class var tempURL: URL {
		return URL(fileURLWithPath: tempPath, isDirectory: true)
	}
	
	class var tempPath: String {
		return NSTemporaryDirectory()
	}
	
	class var bundlePath: String {
		return Bundle.main.bundlePath
	}
	
	
	
	class func openURL(_ path: String, completion: ((Bool)->())? = nil) {

		// Validate URL
		guard let url = URL(string: path) else {
			ruPrint("ERROR can't open URL, Invalid URL: \(path)")
			completion?(false)
			return
		}

		
		// Show Settings
		if #available(iOS 10.0, *) {
			UIApplication.shared.open(url, completionHandler: completion)
		} else {
			UIApplication.shared.openURL(url)
			if let callback = completion {
				RUTools.runAfter(0.1) {
					callback(true)
				}
			}
		}
	}
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Image
	////////////////////////////////////////////////////////////////////////////
	
	func image(withText text: String, color: UIColor, font: UIFont) -> UIImage? {
		let string = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: font])
		let rect = string.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
		                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,  
		                                   context: nil)
		UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.width, height: rect.height), false, 1.0)
		string.draw(in: rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
	

	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Threads
	////////////////////////////////////////////////////////////////////////////
	
	class func runAfter(_ closure: @escaping ()->()) {
		OperationQueue.main.addOperation {
			closure()
		}
	}

	class func runAfter(_ delay:Double, closure: @escaping ()->()) {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
	}
	
	class func runInBackground(_ closure: @escaping ()->()) {
		DispatchQueue(label: "SwiftFramework.task", attributes: []).async(execute: closure)
	}
	
	class func runOnMainThread(_ closure: @escaping ()->()) {
		if Thread.isMainThread {
			closure()
		} else {
			DispatchQueue.main.async(execute: closure)
		}
	}

	class func runOnMainThreadSync(_ closure: @escaping ()->()) {
		// Current thread will wait until this ends
		if Thread.isMainThread {
			closure()
		} else {
			DispatchQueue.main.sync(execute: closure)
		}
	}

	class func runOnMainThreadAsync(_ closure: @escaping ()->()) {
		// Current thread will continue execution
		if Thread.isMainThread {
			closure()
		} else {
			RUTools.runAfter(closure)
		}
	}
	
	class func runSynced(_ lock: AnyObject, closure: () -> ()) {
		objc_sync_enter(lock)
		closure()
		objc_sync_exit(lock)
	}
	
	


	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Animations
	////////////////////////////////////////////////////////////////////////////
	
	class func instantTransaction(_ action: ()->()) {
//		CATransaction.flush()
		CATransaction.begin()
//		CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
		CATransaction.setDisableActions(true)

		action()
		
		CATransaction.commit()
	}
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Math
	////////////////////////////////////////////////////////////////////////////

	class func radToDeg(_ value: Double) -> Double {
		return value * 57.295779513082320876798154814105170332405472466564321549160
	}

	class func degToRad(_ value: Double) -> Double {
		return value * 0.0174532925199432957692369076848861271344287188854172545609
	}

	class func radToDegF(_ value: CGFloat) -> CGFloat {
		return value * 57.295779513082320876798154814105170332405472466564321549160
	}
	
	class func degToRadF(_ value: CGFloat) -> CGFloat {
		return value * 0.0174532925199432957692369076848861271344287188854172545609
	}
	
	

	
	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Notifications
	////////////////////////////////////////////////////////////////////////////
	
	class var badgesEnabled: Bool {
#if IOS7
		if #available(iOS 8.0, *) {
			
			if let settings = UIApplication.shared.currentUserNotificationSettings {
				return settings.types.contains(.badge)
			} else {
				return false
			}
			
		} else {
			return UIApplication.shared.enabledRemoteNotificationTypes().contains(.badge)
		}
#else
		if let settings = UIApplication.shared.currentUserNotificationSettings {
			return settings.types.contains(.badge)
		} else {
			return false
		}
#endif
	}

	class var alertsEnabled: Bool {
#if IOS7
		if #available(iOS 8.0, *) {
			if let settings = UIApplication.shared.currentUserNotificationSettings {
				return settings.types.contains(.alert)
			} else {
				return false
			}
		} else {
			return UIApplication.shared.enabledRemoteNotificationTypes().contains(.alert)
		}
#else
		if let settings = UIApplication.shared.currentUserNotificationSettings {
			return settings.types.contains(.alert)
		} else {
			return false
		}
#endif
	}
	
	

	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Inspect
	////////////////////////////////////////////////////////////////////////////
	
	class var timestamp: Double {
		return CACurrentMediaTime()
	}
	
	class func listFonts() {
		for familyName in UIFont.familyNames {
			print("-- FamilyName = \(familyName)")
			for name in UIFont.fontNames(forFamilyName: familyName) {
				print("     FontName = \(name)")
			}
		}
	}

	class var isiPad: Bool {
		return UIDevice.current.userInterfaceIdiom == .pad
	}
	
	class var orientation: UIDeviceOrientation {
		
		var value = UIDevice.current.orientation
		if value == UIDeviceOrientation.unknown {
			let ivalue = UIApplication.shared.statusBarOrientation
			switch ivalue {
			case .portrait:
				value = .portrait
			case .portraitUpsideDown:
				value = .portraitUpsideDown
			case .landscapeLeft:
				value = .landscapeRight
			case .landscapeRight:
				value = .landscapeLeft
			default:
				return value
			}
		}
		return value
	}

	class var version: String {
		guard let dictionary = Bundle.main.infoDictionary  else { return "" }
		let version = dictionary["CFBundleShortVersionString"] as! String
		let build = dictionary["CFBundleVersion"] as! String
		return "V\(version) build \(build)"
	}

	class var build: Int {
		guard let dictionary = Bundle.main.infoDictionary  else { return 0 }
		let build = dictionary["CFBundleVersion"] as! String
		return Int(build) ?? 0
	}


	// Detect if the current device supports Blur Effect
	fileprivate static var _blurEnabled: Bool? = nil
	class var blurEnabled: Bool {
		if let blur = _blurEnabled {
			return blur && !UIAccessibilityIsReduceTransparencyEnabled()
		}
		let toolbar = UIToolbar()
		toolbar.setNeedsLayout()
		toolbar.layoutIfNeeded()
		let effectView = UIVisualEffectView(effect: UIBlurEffect())
		effectView.setNeedsLayout()
		effectView.layoutIfNeeded()
		_blurEnabled = _hasBlur(toolbar) || _hasBlur(effectView)
		return _blurEnabled!
	}
	fileprivate class func _hasBlur(_ onView: UIView) -> Bool {
		if let filters = onView.layer.filters {
			for filter in filters {
				if let name = (filter as AnyObject).value(forKey: "name") as? String {
					if name.lowercased().contains("blur") {
						return true
					}
				}
			}
		}
		for subview in onView.subviews {
			if _hasBlur(subview) {
				return true
			}
		}
		return false
	}

	
	class func inspectNotifications() {
		NotificationCenter.default.addObserver(forName: nil, object: nil, queue: nil) {
			(notification: Notification!) in

			ruPrint("NOTIFICATION Name = \(notification.name.rawValue)   Object = \(notification.object ?? "nil")")
		}
	}
	

	
	
	
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Device
	////////////////////////////////////////////////////////////////////////////
	
	private static var _deviceName: String? = nil
	class var deviceName: String {
		if let name = _deviceName {
			return name
		}
		
		
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		let identifier = machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			_deviceName = identifier + String(UnicodeScalar(UInt8(value)))
			return _deviceName!
		}
		
		switch identifier {
		case "iPod5,1":                                 	_deviceName = "iPod Touch 5"; return _deviceName!
		case "iPod7,1":                                 	_deviceName = "iPod Touch 6"; return _deviceName!
		case "iPhone3,1", "iPhone3,2", "iPhone3,3":     	_deviceName = "iPhone 4"; return _deviceName!
		case "iPhone4,1":                               	_deviceName = "iPhone 4s"; return _deviceName!
		case "iPhone5,1", "iPhone5,2":                  	_deviceName = "iPhone 5"; return _deviceName!
		case "iPhone5,3", "iPhone5,4":                  	_deviceName = "iPhone 5c"; return _deviceName!
		case "iPhone6,1", "iPhone6,2":                  	_deviceName = "iPhone 5s"; return _deviceName!
		case "iPhone7,2":                               	_deviceName = "iPhone 6"; return _deviceName!
		case "iPhone7,1":                               	_deviceName = "iPhone 6 Plus"; return _deviceName!
		case "iPhone8,1":                               	_deviceName = "iPhone 6s"; return _deviceName!
		case "iPhone8,2":                               	_deviceName = "iPhone 6s Plus"; return _deviceName!
		case "iPhone9,1", "iPhone9,3":                  	_deviceName = "iPhone 7"; return _deviceName!
		case "iPhone9,2", "iPhone9,4":                  	_deviceName = "iPhone 7 Plus"; return _deviceName!
		case "iPhone8,4":                               	_deviceName = "iPhone SE"; return _deviceName!
		case "iPhone10,1", "iPhone10,4":                	_deviceName = "iPhone 8"; return _deviceName!
		case "iPhone10,2", "iPhone10,5":                	_deviceName = "iPhone 8 Plus"; return _deviceName!
		case "iPhone10,3", "iPhone10,6":                	_deviceName = "iPhone X"; return _deviceName!
		case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":	_deviceName = "iPad 2"; return _deviceName!
		case "iPad3,1", "iPad3,2", "iPad3,3":           	_deviceName = "iPad 3"; return _deviceName!
		case "iPad3,4", "iPad3,5", "iPad3,6":           	_deviceName = "iPad 4"; return _deviceName!
		case "iPad4,1", "iPad4,2", "iPad4,3":           	_deviceName = "iPad Air"; return _deviceName!
		case "iPad5,3", "iPad5,4":                      	_deviceName = "iPad Air 2"; return _deviceName!
		case "iPad6,11", "iPad6,12":                    	_deviceName = "iPad 5"; return _deviceName!
		case "iPad2,5", "iPad2,6", "iPad2,7":           	_deviceName = "iPad Mini"; return _deviceName!
		case "iPad4,4", "iPad4,5", "iPad4,6":           	_deviceName = "iPad Mini 2"; return _deviceName!
		case "iPad4,7", "iPad4,8", "iPad4,9":           	_deviceName = "iPad Mini 3"; return _deviceName!
		case "iPad5,1", "iPad5,2":                      	_deviceName = "iPad Mini 4"; return _deviceName!
		case "iPad6,3", "iPad6,4":                      	_deviceName = "iPad Pro 9.7 Inch"; return _deviceName!
		case "iPad6,7", "iPad6,8":                      	_deviceName = "iPad Pro 12.9 Inch"; return _deviceName!
		case "iPad7,1", "iPad7,2":                      	_deviceName = "iPad Pro 12.9 Inch 2. Generation"; return _deviceName!
		case "iPad7,3", "iPad7,4":                      	_deviceName = "iPad Pro 10.5 Inch"; return _deviceName!
		case "AppleTV5,3":                              	_deviceName = "Apple TV"; return _deviceName!
		case "AppleTV6,2":                              	_deviceName = "Apple TV 4K"; return _deviceName!
		case "AudioAccessory1,1":                       	_deviceName = "HomePod"; return _deviceName!
		case "i386", "x86_64":                          	_deviceName = "Simulator"; return _deviceName!
		default:                                        	_deviceName = identifier; return _deviceName!
		}
	}
	
	
	private static var _devicePriorToiPhoneX: Bool? = nil
	class var devicePriorToiPhoneX: Bool {
		if let device = _devicePriorToiPhoneX {
			return device
		}
		
		switch RUTools.deviceName {
		case "iPod Touch 5", "iPod Touch 6", "iPhone 4", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone 6", "iPhone 6 Plus", "iPhone 6s", "iPhone 6s Plus", "iPhone 7", "iPhone 7 Plus", "iPhone SE", "iPhone 8", "iPhone 8 Plus":
			_devicePriorToiPhoneX = true
			return true
		case "iPad 2", "iPad 3", "iPad 4", "iPad Air", "iPad Air 2", "iPad 5", "iPad Mini", "iPad Mini 2", "iPad Mini 3", "iPad Mini 4":
			_devicePriorToiPhoneX = false
			return false
		default:
			_devicePriorToiPhoneX = false
			return false
		}
	}

	private static var _devicePriorToiPhone8: Bool? = nil
	class var devicePriorToiPhone8: Bool {
		if let device = _devicePriorToiPhone8 {
			return device
		}
		
		switch RUTools.deviceName {
		case "iPod Touch 5", "iPod Touch 6", "iPhone 4", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone 6", "iPhone 6 Plus", "iPhone 6s", "iPhone 6s Plus", "iPhone 7", "iPhone 7 Plus", "iPhone SE":
			_devicePriorToiPhone8 = true
			return true
		case "iPad 2", "iPad 3", "iPad 4", "iPad Air", "iPad Air 2", "iPad 5", "iPad Mini", "iPad Mini 2", "iPad Mini 3", "iPad Mini 4":
			_devicePriorToiPhone8 = false
			return false
		default:
			_devicePriorToiPhone8 = false
			return false
		}
	}

	private static var _devicePriorToiPhone7: Bool? = nil
	class var devicePriorToiPhone7: Bool {
		if let device = _devicePriorToiPhone7 {
			return device
		}
		
		switch RUTools.deviceName {
		case "iPod Touch 5", "iPod Touch 6", "iPhone 4", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone 6", "iPhone 6 Plus", "iPhone 6s", "iPhone 6s Plus", "iPhone SE":
			_devicePriorToiPhone7 = true
			return true
		case "iPad 2", "iPad 3", "iPad 4", "iPad Air", "iPad Air 2", "iPad 5", "iPad Mini", "iPad Mini 2", "iPad Mini 3", "iPad Mini 4":
			_devicePriorToiPhone7 = false
			return false
		default:
			_devicePriorToiPhone7 = false
			return false
		}
	}

	private static var _devicePriorToiPhone6S: Bool? = nil
	class var devicePriorToiPhone6S: Bool {
		if let device = _devicePriorToiPhone6S {
			return device
		}
		
		switch RUTools.deviceName {
		case "iPod Touch 5", "iPod Touch 6", "iPhone 4", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone 6", "iPhone 6 Plus", "iPhone SE":
			_devicePriorToiPhone6S = true
			return true
		case "iPad 2", "iPad 3", "iPad 4", "iPad Air", "iPad Air 2", "iPad 5", "iPad Mini", "iPad Mini 2", "iPad Mini 3", "iPad Mini 4":
			_devicePriorToiPhone6S = false
			return false
		default:
			_devicePriorToiPhone6S = false
			return false
		}
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Memory
	////////////////////////////////////////////////////////////////////////////
	
	/// Total device memory in MB
	private static var _totalMemory: Float? = nil
	class var totalMemory: Float {
		if let memory = _totalMemory {
			return memory
		}
		_totalMemory = Float(Double(ProcessInfo.processInfo.physicalMemory) / 1000000)
		return _totalMemory!
	}
	
	/// Current used memory in MB
	class var usedMemory: Float {
		var taskInfo = mach_task_basic_info()
		var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
		let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
			$0.withMemoryRebound(to: integer_t.self, capacity: 1) {
				task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
			}
		}
		
		if kerr == KERN_SUCCESS {
			return Float(Double(taskInfo.resident_size) / 1000000)
		} else {
			print("ERROR Getting Used Memory, task_info(): " + (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
			return 0
		}
	}

	/// Available Memory in MB
	class var availableMemory: Float {
		return totalMemory - usedMemory
	}

	/// Used memory percentage
	class var usedPercentMemory: Float {
		return (usedMemory / totalMemory) * 100
	}

	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// MARK: Helpers
	////////////////////////////////////////////////////////////////////////////

	public final class ObjectAssociation<T: AnyObject> {
		
		private let policy: objc_AssociationPolicy
		
		/// - Parameter policy: An association policy that will be used when linking objects.
		public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
			self.policy = policy
		}
		
		/// Accesses associated object.
		/// - Parameter index: An object whose associated object is to be accessed.
		public subscript(index: AnyObject) -> T? {
			
			get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
			set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
		}
	}
}




















