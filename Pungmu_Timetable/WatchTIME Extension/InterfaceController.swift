//
//  InterfaceController.swift
//  WatchTIME Extension
//
//  Created by 프매씨 on 2015. 11. 2..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var lb_main: WKInterfaceLabel!
    @IBOutlet var lb_title: WKInterfaceLabel!
    
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        lb_main.setText("로딩 중")
        self.setTitle("급식표(점심)")
        
        // Configure interface objects here.
    }
    @IBAction func menu_meal_seleted() {
        // This method is called when watch view controller is about to be visible to user
        let today = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "YYYY/MM/dd"
        
        let now_month = dateFormat.stringFromDate(today).split("/")[1]
        let now_year = dateFormat.stringFromDate(today).split("/")[0]
        let now_day = dateFormat.stringFromDate(today).split("/")[2]
        let meal:Meal
        
        meal = Meal(Int(now_year)!,Int(now_month)!,Meal.Mode.unLive)
        
        Chg_text("로딩 중", "")
        
        if meal.List.count == 1
        {
            if meal.error == Meal.Error.NoData
            {
                Chg_text("저장된 급식정보가 없습니다.\n\n\n어플을 실행해 업데이트 해주세요.","")
            }
            else if meal.error == Meal.Error.NeedUpdate
            {
                Chg_text("저장된 급식정보의 유효기간이 지났습니다.\n\n\n어플을 실행해 업데이트 해주세요.","")
            }
        }
        else if meal.List.count < now_day.toInt()
        {
            Chg_text("저장된 급식정보에 문제가 있습니다.\n수동으로 설정에서 업데이트를 해주세요.","")
        }
        else
        {
            dateFormat.dateFormat = "YYYY년 MM월 dd일 급식표"
            Chg_text(meal.Lunch[now_day.toInt()], dateFormat.stringFromDate(today))
        }
    }
    @IBAction func menu_timetable_seleted() {
    }
    @IBAction func menu_meal_dinner_selected() {
        // This method is called when watch view controller is about to be visible to user
        let today = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "YYYY/MM/dd"
        
        let now_month = dateFormat.stringFromDate(today).split("/")[1]
        let now_year = dateFormat.stringFromDate(today).split("/")[0]
        let now_day = dateFormat.stringFromDate(today).split("/")[2]
        let meal:Meal
        
        meal = Meal(Int(now_year)!,Int(now_month)!,Meal.Mode.unLive)
        
        Chg_text("로딩 중", "")
        
        if meal.List.count == 1
        {
            if meal.error == Meal.Error.NoData
            {
                Chg_text("저장된 급식정보가 없습니다.\n\n\n어플을 실행해 업데이트 해주세요.","")
            }
            else if meal.error == Meal.Error.NeedUpdate
            {
                Chg_text("저장된 급식정보의 유효기간이 지났습니다.\n\n\n어플을 실행해 업데이트 해주세요.","")
            }
        }
        else if meal.List.count < now_day.toInt()
        {
            Chg_text("저장된 급식정보에 문제가 있습니다.\n수동으로 설정에서 업데이트를 해주세요.","")
        }
        else
        {
            dateFormat.dateFormat = "YYYY년 MM월 dd일 급식표"
            Chg_text(meal.Dinner[now_day.toInt()], dateFormat.stringFromDate(today))
        }
    }

    override func willActivate() {
        
        // This method is called when watch view controller is about to be visible to user
        let today = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "YYYY/MM/dd"
        
        let now_month = dateFormat.stringFromDate(today).split("/")[1]
        let now_year = dateFormat.stringFromDate(today).split("/")[0]
        let now_day = dateFormat.stringFromDate(today).split("/")[2]
        let meal:Meal
        
        meal = Meal(Int(now_year)!,Int(now_month)!,Meal.Mode.unLive)
        
        Chg_text("로딩 중", "")
        
        if meal.List.count == 1
        {
            if meal.error == Meal.Error.NoData
            {
                Chg_text("저장된 급식정보가 없습니다.\n\n\n어플을 실행해 업데이트 해주세요.","")
            }
            else if meal.error == Meal.Error.NeedUpdate
            {
                Chg_text("저장된 급식정보의 유효기간이 지났습니다.\n\n\n어플을 실행해 업데이트 해주세요.","")
            }
        }
        else if meal.List.count < now_day.toInt()
        {
            Chg_text("저장된 급식정보에 문제가 있습니다.\n수동으로 설정에서 업데이트를 해주세요.","")
        }
        else
        {
            dateFormat.dateFormat = "YYYY년 MM월 dd일 급식표"
            Chg_text(meal.Lunch[now_day.toInt()], dateFormat.stringFromDate(today))
        }

        //Chg_text(Data_Save.stringForKey(Data_Key.Setting_Finish)! ,Data_Save.stringForKey(Data_Key.Setting_Finish)!)
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func Chg_text(str:String,_ str2:String)
    {
        dispatch_async(dispatch_get_main_queue()){
            self.lb_main.setText(str)
            self.lb_title.setText(str2)
        }
    }

}
