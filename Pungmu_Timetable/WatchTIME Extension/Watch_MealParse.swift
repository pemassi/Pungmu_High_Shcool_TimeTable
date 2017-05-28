//
//  MealParse.swift
//  Pungmu_Timetable
//
//  Created by 프매씨 on 2015. 10. 26..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

//http://hes.goe.go.kr/sts_sci_md00_001.do?schulCode=J100004919&ay=2015&mm=10&schulCrseScCode=4&schulKndScCode=04
import Foundation

class Meal
{
    internal let List:[String]
    internal let Lunch:[String]
    internal let Dinner:[String]
    internal var error:Error
    
    internal enum Mode
    {
        case Live
        case unLive
        case UpDate
    }
    
    internal enum Error
    {
        case None       //Notting
        case NoData     //정보가 없음
        case NeedUpdate //기간이 지남(한달이 지남)
        case InternetError
    }
    
    internal enum Result
    {
        case None
        case Error
        case Internet
    }
    
    init(_ year:Int, _ month:Int, _ mode:Mode)
    {
        if mode == Mode.Live
        {
            var target_month:String = month.toString()
            if month < 10
            {
                target_month = "0" + month.toString()
            }
            
            let todays = NSDate()
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "YYYY/MM"
            let save_date:String
            
            if let date = Data_Save.stringForKey(Data_Key.Meal_Update)
            {
                save_date = date
            }
            else
            {
                save_date = "0000/00"
            }
            
            if (year.toString() + "/" + target_month) == dateFormat.stringFromDate(todays) && (save_date == dateFormat.stringFromDate(todays))
            {
                List = Data_Save.stringArrayForKey(Data_Key.Meal_List)!
                Lunch = Data_Save.stringArrayForKey(Data_Key.Meal_Lunch)!
                Dinner = Data_Save.stringArrayForKey(Data_Key.Meal_Dinner)!
                error = Error.None
            }
            else
            {
                
                let Get_Data = Meal_Data.Get_List(year, month)
                List = Get_Data.List
                Lunch = Get_Data.Lunch
                Dinner = Get_Data.Dinner
                error = Get_Data.error
            }
        }
        else
        {
            let todays = NSDate()
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "YYYY/MM"
            
            if let date = Data_Save.stringForKey(Data_Key.Meal_Update)
            {
                if date == dateFormat.stringFromDate(todays)
                {
                    List = Data_Save.stringArrayForKey(Data_Key.Meal_List)!
                    Lunch = Data_Save.stringArrayForKey(Data_Key.Meal_Lunch)!
                    Dinner = Data_Save.stringArrayForKey(Data_Key.Meal_Dinner)!
                    error = Error.None
                }
                else
                {
                    List = ["Error"]
                    Lunch = ["Error"]
                    Dinner = ["Error"]
                    error = .NeedUpdate
                }
                
            }
            else
            {
                List = ["Error"]
                Lunch = ["Error"]
                Dinner = ["Error"]
                error = .NoData
            }
        }
    }
    
    static func UpDate(year:Int, _ month:Int) -> Error
    {
        var target_month:String = month.toString()
        if month < 10
        {
            target_month = "0" + month.toString()
        }
        
        let todays = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "YYYY/MM"
        let save_date:String
        
        if let date = Data_Save.stringForKey(Data_Key.Meal_Update)
        {
            save_date = date
        }
        else
        {
            save_date = "0000/00"
        }
        
        if (year.toString() + "/" + target_month) == dateFormat.stringFromDate(todays) && (save_date == dateFormat.stringFromDate(todays))
        {
            return .None
        }
        else
        {
            let Get_Data = Meal_Data.Get_List(year,month)
            
            //Update Data
            Data_Save.setValue(Get_Data.List, forKey: Data_Key.Meal_List)
            Data_Save.setValue(Get_Data.Lunch, forKey: Data_Key.Meal_Lunch)
            Data_Save.setValue(Get_Data.Dinner, forKey: Data_Key.Meal_Dinner)
            
            let todays = NSDate()
            let dateFormat = NSDateFormatter()
            
            dateFormat.dateFormat = "YYYY/MM"
            Data_Save.setValue(dateFormat.stringFromDate(todays),forKey: Data_Key.Meal_Update)
            
            Data_Save.synchronize()
            
            return Get_Data.error
        }
    }
    
    static func StrongUpDate(year:Int, _ month:Int) -> Error
    {
        let Get_Data = Meal_Data.Get_List(year,month)
        
        //Update Data
        Data_Save.setValue(Get_Data.List, forKey: Data_Key.Meal_List)
        Data_Save.setValue(Get_Data.Lunch, forKey: Data_Key.Meal_Lunch)
        Data_Save.setValue(Get_Data.Dinner, forKey: Data_Key.Meal_Dinner)
        
        let todays = NSDate()
        let dateFormat = NSDateFormatter()
        
        dateFormat.dateFormat = "YYYY/MM"
        Data_Save.setValue(dateFormat.stringFromDate(todays),forKey: Data_Key.Meal_Update)
        
        Data_Save.synchronize()
        
        return Get_Data.error
    }
}

class Meal_Data
{
    static func Get_List(year:Int, _ month:Int) -> (List:[String], Lunch:[String], Dinner:[String], error:Meal.Error)
    {
        
        var target_month:String = month.toString()
        if month < 10
        {
            target_month = "0" + month.toString()
        }
        
        //let URL = "http://hes.goe.go.kr/sts_sci_md00_001.do?schulCode=J100004919&ay=" + String(year) + "&mm=" + target_month + "&schulCrseScCode=4&schulKndScCode=04"
        //J100006717
        let URL = "http://hes.goe.go.kr/sts_sci_md00_001.do?schulCode=J100004919&ay=" + String(year) + "&mm=" + target_month + "&schulCrseScCode=4&schulKndScCode=04"
        let Data:String
        var Set_List = [String](count: 32, repeatedValue: "")
        var Set_Lunch = [String](count: 32, repeatedValue: "")
        var Set_Dinner = [String](count: 32, repeatedValue: "")
        
        
        if let get_data:String = Webkit.GetWebRespone(URL)
        {
            Data = get_data.split("<tbody>\r\n")[1]
            
            
            for var i=1; i<32; i++
            {
                let confrim = Data.split("<td><div>"+String(i)+"<br />")[1].split("</div></td>")[0].replace("<br />","\n")
                if confrim.containsString("ERROR") == true
                {
                    Set_List[i] = "급식정보가 없습니다"
                    Set_Lunch[i] = Set_List[i]
                    Set_Dinner[i] = Set_List[i]
                }
                else
                {
                    Set_List[i] = Data.split("<td><div>"+String(i)+"<br />")[1].split("</div></td>")[0].replace("<br />","\n")
                    
                    //석식이 없을 경우
                    if Set_List[i].containsString("[석식]") == true
                    {
                        Set_Lunch[i] = Set_List[i].split("[중식]\n")[1].split("[석식]")[0]
                        Set_Dinner[i] = Set_List[i].split("[석식]")[1]
                    }
                    else
                    {
                        Set_Lunch[i] = Set_List[i].replace("[중식]","")
                        Set_Dinner[i] = "급식정보가 없습니다"
                    }
                }
            }
            
            return (Set_List,Set_Lunch,Set_Dinner,.None)
        }
        else
        {
            return(["ERROR"],["ERROR"],["ERROR"],.InternetError)
        }
    }
}
