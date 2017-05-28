//
//  Global.swift
//  풍무고등학교
//
//  Created by 프매씨 on 2015. 10. 26..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import Foundation
import UIKit

import SystemConfiguration

public let Group_ID:String = "group.bundle.id.of.pungmu.sharedData"
public let Data_Save:NSUserDefaults = NSUserDefaults(suiteName: Group_ID)!

public enum Data_Key
{
    static let Meal_List = "Meal_Teacher"
    static let Meal_Lunch = "Meal_Subject"
    static let Meal_Dinner = "Meal_FristClass"
    static let Meal_Update = "Meal_Update"
    static let Time_Teacher = "Time_Teacher"
    static let Time_Subject = "Time_Subject"
    static let Time_FristClass = "Time_FristClass"
    static let Time_SecondClass = "Time_SecondClass"
    static let Time_ThridClass = "Time_ThridClass"
    static let Time_Update = "Time_Update"
    static let Data_Grade = "Data_Grade"
    static let Data_Class = "Data_Class"
    static let Setting_LiveUpdate = "Setting_LiveUpdate"
    static let Push_Data = "Push_Data"
}


public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

class Global {
    
    static var WebData:String?
}

class Webkit {
    
    static func GetWebRespone(urls: String) -> String?
    {
        if let Data = NSData(contentsOfURL: NSURL(string: "\(urls)")!) {
            return NSString(data: Data, encoding: NSUTF8StringEncoding)!.toString()
        }
        return nil
    }
    
    static func GetWebRespone(urls: String) -> NSString?
    {
        if let Data = NSData(contentsOfURL: NSURL(string: "\(urls)")!) {
            return NSString(data: Data, encoding: NSUTF8StringEncoding)
        }
        return nil
    }
    
    static func GetWebResponeNSData(urls: String) -> NSData?
    {
        if let Data = NSData(contentsOfURL: NSURL(string: "\(urls)")!) {
            return Data
        }
        return nil
    }
}

class MessageBox {
    
    internal var ButtonName:String
        {
        get{
            return _Button
        }
        set{
            _Button = ButtonName
        }
    }
    
    internal var View:UIViewController
        {
        get{
            return _View
        }
        set{
            _View = View
            self.reload()
        }
    }
    
    internal var Subject:String
        {
        get{
            return _Subject
        }
        set{
            _Subject = Subject
            self.reload()
        }
    }
    
    internal var Body:String
        {
        get{
            return _Body
        }
        set{
            _Body = Body
            self.reload()
        }
    }
    
    internal var preStyle:UIAlertControllerStyle
        {
        get{
            return _preStyle
        }
        set{
            _preStyle = preStyle
            self.reload()
        }
    }
    
    private var _View:UIViewController
    private var _Subject:String
    private var _Body:String
    private var _Button:String = "확인"
    private var _preStyle:UIAlertControllerStyle = UIAlertControllerStyle.Alert
    private var flag_addAction = false
    internal var alertController:UIAlertController
    
    init(View:UIViewController, Subject:String, Body:String)
    {
        _View = View
        _Subject = Subject
        _Body = Body
        
        alertController = UIAlertController(title: _Subject, message: _Body, preferredStyle: _preStyle)
    }
    
    init(View:UIViewController, Subject:String, Body:String, AlertAction:UIAlertAction)
    {
        _View = View
        _Subject = Subject
        _Body = Body
        
        alertController = UIAlertController(title: _Subject, message: _Body, preferredStyle: _preStyle)
        alertController.addAction(AlertAction)
    }
    
    
    private func reload()
    {
        alertController = UIAlertController(title: _Subject, message: _Body, preferredStyle: _preStyle)
    }
    
    internal func Show()
    {
        if flag_addAction == false
        {
            alertController.addAction(UIAlertAction(title: _Button, style: UIAlertActionStyle.Cancel,handler: nil))
        }
        _View.presentViewController(alertController, animated: true, completion: nil)
    }
    
    internal func addAction(title: String, style:UIAlertActionStyle)
    {
        alertController.addAction(UIAlertAction(title: title, style: style,handler: nil))
        flag_addAction = true
    }
    
    static func Show(View:UIViewController, Subject:String, Body:String, Button:String)
    {
        let alertController = UIAlertController(title: Subject, message: Body, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: Button, style: UIAlertActionStyle.Default,handler: nil))
        View.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

//편의를 위한 확장 선언
extension String {
    
    func split(splitter: String) -> Array<String> {
        if self.containsString(splitter)
        {
            return self.componentsSeparatedByString(splitter)
        }
        else
        {
            return ["ERROR","NOT FOUND SPLITTER"]
        }
    }
    
    func replace(Data: String, _ target:String) -> String{
        
        return self.stringByReplacingOccurrencesOfString(Data, withString: target)
        
    }
    
    func toInt() -> Int!
    {
        return Int(self)!
    }
    
    func toNSString() -> NSString
    {
        return self as NSString
    }
    
}

extension Int {
    
    func toString() -> String{
        return String(self)
    }
    
}

extension NSString {
    
    func split(splitter: String) -> Array<NSString> {
        if self.containsString(splitter)
        {
            return self.componentsSeparatedByString(splitter)
        }
        else
        {
            return ["ERROR","NOT FOUND SPLITTER"]
        }
    }
    
    func toString() -> String
    {
        return self as String
    }
    
}
