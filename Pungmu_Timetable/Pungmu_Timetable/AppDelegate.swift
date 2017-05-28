//
//  AppDelegate.swift
//  Pungmu_Timetable
//
//  Created by 프매씨 on 2015. 10. 23..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //백그라운드 패치
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        //UI디자인
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.orangeColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        var Live_Update:Bool = false
        
        //push_show("TEST")
        /*
        if let a = Data_Save.stringForKey(Data_Key.Push_Data)
        {
            push_show("kkkk" + a)
        }
        else
        {
            push_show("NOT")
        }
        */
        if let _ = Data_Save.stringForKey(Data_Key.Setting_Finish)
        {
            let user_kind = Data_Save.stringForKey(Data_Key.Setting_About)!.toInt()
            
            if let liveupdate = Data_Save.stringForKey(Data_Key.Setting_LiveUpdate)
            {
                if Int(liveupdate) == 1
                {
                    Live_Update = true
                }
            }
            
            if (Reachability.isConnectedToNetwork() == true) && (Live_Update == true)
            {
                if user_kind == 0
                {
                    let Grade = Data_Save.stringForKey(Data_Key.Data_Grade)!.toInt()
                    let Class = Data_Save.stringForKey(Data_Key.Data_Class)!.toInt()
                    let live_timetable = TimeTable(.Live)
                    let unlive_timetable = TimeTable(.unLive)
                    
                    let live_table = live_timetable.GetTimetable(Grade, Class)
                    let unlive_table = unlive_timetable.GetTimetable(Grade, Class)
                    
                    if live_table[0] != "ERROR"
                    {
                        let today = NSDate()
                        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                        let myComponents = myCalendar.components(.Weekday, fromDate: today)
                        
                        let weekDay = myComponents.weekday - 2
                        
                        var live_tables:[String] = live_table[weekDay].split(",")
                        var unlive_tables:[String] = unlive_table[weekDay].split(",")
                        var set_string:String = ""
                        for var j = 1; j<8; j++
                        {
                            if live_tables[j] != unlive_tables[j]
                            {
                                set_string = set_string + "\(j)교시 수업이 " + String(unlive_timetable.GetSubjectNmae(Int(unlive_tables[j])!)) + "(" + unlive_timetable.GetTeacherName(Int(unlive_tables[j])!) + ")에서 " + String(live_timetable.GetSubjectNmae(Int(live_tables[j])!)) + "(" + live_timetable.GetTeacherName(Int(live_tables[j])!) + ")" + "으로 변경되었습니다.\n\n"
                            }
                        }
                        
                        //push_show("Suceecss")
                        
                        if set_string == ""
                        {
                            completionHandler(UIBackgroundFetchResult.NoData)
                        }
                        else
                        {
                            if let data = Data_Save.stringForKey(Data_Key.Push_Data)
                            {
                                if data != set_string
                                {
                                    push_show(set_string)
                                    completionHandler(UIBackgroundFetchResult.NewData)
                                    Data_Save.setValue(set_string, forKey: Data_Key.Push_Data)
                                    Data_Save.synchronize()
                                }
                                else
                                {
                                    completionHandler(UIBackgroundFetchResult.NoData)
                                }
                            }
                            else
                            {
                                push_show(set_string)
                                Data_Save.setValue(set_string, forKey: Data_Key.Push_Data)
                                Data_Save.synchronize()
                                completionHandler(UIBackgroundFetchResult.NewData)
                            }
                            
                        }
                        
                    }
                    else
                    {
                        completionHandler(UIBackgroundFetchResult.Failed)
                    }
                    
                    
                }
                else if user_kind == 1
                {
                    //push_show("Suceecss_T")
                    completionHandler(UIBackgroundFetchResult.NewData)
                }
                else
                {
                    completionHandler(UIBackgroundFetchResult.Failed)
                }
                
            }
            else if Live_Update == false
            {
                completionHandler(UIBackgroundFetchResult.NoData)
            }
            else
            {
                completionHandler(UIBackgroundFetchResult.Failed)
            }
        }
        else
        {
            completionHandler(UIBackgroundFetchResult.NoData)
        }
        
        
        
    }
    
    
    func push_show(text:String)
    {
        let now: NSDateComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: NSDate())
        
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let date = cal.dateBySettingHour(now.hour, minute: now.minute, second: 0 + 1, ofDate: NSDate(), options: NSCalendarOptions())
        let reminder = UILocalNotification()
        reminder.fireDate = date
        reminder.alertBody = text
        reminder.alertAction = "밀어서 확인하기"
        reminder.soundName = "sound.aif"
        reminder.category = "CATEGORY_ID"
        
        UIApplication.sharedApplication().scheduleLocalNotification(reminder)
    }

    

}

