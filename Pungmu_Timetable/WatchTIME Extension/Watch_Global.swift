//
//  Global.swift
//  TEST
//
//  Created by 프매씨 on 2015. 9. 25..
//  Copyright © 2015년 프매씨. All rights reserved.
//

import UIKit

public var User_Grade:Int = 0
public var User_Class:Int = 0
public var User_Kind:Int = 0
public var User_Teacher_Code:Int = 0
public var User_Teacher_Name:String  = ""
public var User_Live_Update:Bool = false
public let Group_ID:String = "group.bundle.id.of.pungmu.app.sharedData"
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
    static let Time_TeacherTimeTable = "Time_TeacherTimeTable"
    static let Data_Grade = "Data_Grade"
    static let Data_Class = "Data_Class"
    static let Setting_LiveUpdate = "Setting_LiveUpdate"
    static let Setting_About = "Setting_About"
    static let Setting_Kind = "Kind_About" //0 - 학생 1 - 선생님
    static let Setting_Finish = "Setting_Finish"
    static let Setting_Teacher_Code = "Teacher_Code"
    static let Setting_Teacher_Name = "Teacher_Name"
    static let Push_Data = "Push_Data"
}

class Share
{
    static let instance = Share()
    var Table:TimeTable?
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
    
    func toInt() -> Int
    {
        return Int(self)!
    }
    
    func toNSString() -> NSString
    {
        return self as NSString
    }
    
    func toUTF8() -> String
    {
        return self.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }
    
    func toEUC_KR() -> String
    {
        return self.stringByAddingPercentEscapesUsingEncoding(0x80000940)!
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
