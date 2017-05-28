//
//  JsonParse.swift
//  Pungmu_Timetable
//
//  Created by 프매씨 on 2015. 10. 23..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import Foundation

class TimeTable
{
    //internal var today:Int
    internal var subject:[String]
    internal var teacher:[String]
    internal var fristclass:[String]
    internal var secondclass:[String]
    internal var thridclass:[String]
    //internal var Request:String
    internal var Max_Class:[Int]
    internal var error:Error
    private let URL = "http://115.20.145.150:4080/_hourdat?sc=43190&nal=0"
    //http://115.20.145.150:4080/_hourdat?sc=43190&nal=0
    //28695
    
    internal enum Mode
    {
        case Live
        case unLive
    }
    
    internal enum Error
    {
        case None       //Notting
        case NeedUpdate //정보가 없음
        case ClassOver  //없는 반의 정보를 읽으려고 할 때
    }
    
    init(_ mode:Mode)
    {
        if mode == Mode.Live
        {
            // Get Data
            let Request:String = Webkit.GetWebRespone(URL)!
            
            // Get Teacher Names
            let name1 = Request.split("\"성명\":[")[1].split("]")[0]
            var name2 = name1.split(",")
            for var i = 0 ; i < name2.count; i++
            {
                name2[i].replace("\"","")
            }
            
            teacher = name2
            
            // Get Today
            //today = Int(_request.split("오늘r\":")[1].split(",")[0])!
            
            // Get Subject Names
            let subject1 = Request.split("과목명\":[")[1].split("]")[0]
            subject1.replace(" ","")
            var subject2 = subject1.split(",")
            for var i = 0 ; i < subject2.count; i++
            {
                subject2[i].replace("\"","")
            }
            subject = subject2
            
            // Get Timetable
            var grade = Request.split("시간표\":[")[1].split("],\"시수표\"")[0].split("[[],[")
            var grade_live = Request.split("학급시간표\":[")[1].split("],\"교사시간표\"")[0].split("[[],[")
            
            var i = 0
            var grade_flag = -1
            var grade_String = [String](count: 3, repeatedValue: "")
            var grade_live_String = [String](count: 3, repeatedValue:"")
            
            while(i+1 < grade.count)
            {
                if (grade[i].rangeOfString("[],") != nil)
                {
                    grade_flag++
                    
                    grade[i].replace("[],[","").replace("]],","")
                    grade_live[i].replace("[],[","").replace("]],","")
                }
                else
                {
                    grade[i].replace("]],","")
                    grade_live[i].replace("]],","")
                }
                
                if grade_flag != -1
                {
                    grade_String[grade_flag] = grade_String[grade_flag] + grade[i] + "/"
                    grade_live_String[grade_flag] = grade_live_String[grade_flag] + grade_live[i] + "/"
                }
                
                i++
            }
            
            let unlive_fristclass = grade_String[0].split("/")
            let unlive_secondclass = grade_String[1].split("/")
            let unlive_thridclass = grade_String[2].split("/")
            
            fristclass = grade_live_String[0].split("/")
            secondclass = grade_live_String[1].split("/")
            thridclass = grade_live_String[2].split("/")
            
            Max_Class = [fristclass.count-1,secondclass.count-1,thridclass.count-1]
            
            error = Error.None
            
            //Update Data
            Data_Save.setValue(unlive_fristclass, forKey: Data_Key.Time_FristClass)
            Data_Save.setValue(unlive_secondclass, forKey: Data_Key.Time_SecondClass)
            Data_Save.setValue(unlive_thridclass, forKey: Data_Key.Time_ThridClass)
            Data_Save.setValue(subject, forKey: Data_Key.Time_Subject)
            Data_Save.setValue(teacher, forKey: Data_Key.Time_Teacher)
            
            let todays = NSDate()
            let dateFormat = NSDateFormatter()
            
            dateFormat.dateFormat = "YYYY/MM/dd"
            Data_Save.setValue(dateFormat.stringFromDate(todays),forKey: Data_Key.Time_Update)
            
            Data_Save.synchronize()
        }
        else
        {
            if let _ = Data_Save.stringForKey(Data_Key.Time_Update)
            {
                fristclass = Data_Save.stringArrayForKey(Data_Key.Time_FristClass)!
                secondclass = Data_Save.stringArrayForKey(Data_Key.Time_SecondClass)!
                thridclass = Data_Save.stringArrayForKey(Data_Key.Time_ThridClass)!
                subject = Data_Save.stringArrayForKey(Data_Key.Time_Subject)!
                teacher = Data_Save.stringArrayForKey(Data_Key.Time_Teacher)!
                error = Error.None
                Max_Class = [fristclass.count-1,secondclass.count-1,thridclass.count-1]
                
            }
            else
            {
                fristclass = ["Error"]
                secondclass = ["Error"]
                thridclass = ["Error"]
                subject = ["Error"]
                teacher = ["Error"]
                error = Error.NeedUpdate
                Max_Class = [-1]
            }
        }
        
    }
    
    internal func GetTeacherName(num : Int) -> String
    {
        let return_data = teacher[num/100].replace("\"","").replace(" ","").replace("os","")
        if return_data == ""
        {
            return "---"
        }
        else
        {
            return return_data
        }
    }
    
    internal func GetTimetable(grade:Int, _ classs:Int) -> [String]
    {
        
        if Max_Class[grade-1] < classs
        {
            error = .ClassOver
            return ["ERROR"]
        }
        
        switch grade
        {
        case 1:
            fristclass[classs-1].replace("]]","")
            return fristclass[classs-1].split("],[")
        case 2:
            secondclass[classs-1].replace("]]","")
            return secondclass[classs-1].split("],[")
        case 3:
            thridclass[classs-1].replace("]]","")
            return thridclass[classs-1].split("],[")
        default:
            return ["ERROR","ERROR"]
        }
    }
    
    internal func GetSubjectNmae(num:Int) -> String
    {
        let return_data = subject[num-(num/100)*100].replace("\"","").replace("NG","").replace(" ","").replace("SE","")
        if return_data == ""
        {
            return "정보없음"
        }
        else
        {
            return return_data
        }
    }
    
    internal func ConvertDays(num:Int) -> String
    {
        switch num
        {
        case 0: return "월요일"
        case 1: return "화요일"
        case 2: return "수요일"
        case 3: return "목요일"
        case 4: return "금요일"
        default: return "ERROR"
        }
    }
    
    static func ConvertDays(num:Int) -> String
    {
        switch num
        {
        case 0: return "월요일"
        case 1: return "화요일"
        case 2: return "수요일"
        case 3: return "목요일"
        case 4: return "금요일"
        default: return "ERROR"
        }
    }
    
}

class TimeTable_Teacher
{
    
    internal var subject:[String]
    internal var teacher:[String]
    internal var teacher_Count:Int
    internal var table:[String]
    internal var error:Error
    private let URL = "http://115.20.145.150:4080/_hourdat?sc=43190&nal=0"
    
    internal enum Mode
    {
        case Live
        case unLive
    }
    
    internal enum Error
    {
        case None       //Notting
        case NeedUpdate //정보가 없음
        case ClassOver  //없는 반의 정보를 읽으려고 할 때
    }
    
    init(_ mode:Mode)
    {
        // Get Data
        let Request:String = Webkit.GetWebRespone(URL)!
        
        // Get Teacher Names
        let name1 = Request.split("\"성명\":[")[1].split("]")[0]
        var name2 = name1.split(",")
        for var i = 0 ; i < name2.count; i++
        {
            name2[i].replace("\"","")
        }
        
        teacher = name2
        
        // Get Today
        teacher_Count = Int(Request.split("\"교사수\":")[1].split(",")[0])!
        
        // Get Subject Names
        let subject1 = Request.split("과목명\":[")[1].split("]")[0]
        subject1.replace(" ","")
        var subject2 = subject1.split(",")
        for var i = 0 ; i < subject2.count; i++
        {
            subject2[i].replace("\"","")
        }
        subject = subject2
        
        // Get Timetable
        var set_table = Request.split("교사시간표\":[")[1].split("]]}")[0].split("[[],[")
        set_table[set_table.count-1].replace("]],","")
        
        table = set_table
        error = .None
        
    }
    
    internal func GetTimetable(target:Int) -> [String]
    {
        
        if table.count == target
        {
            error = .ClassOver
            return ["ERROR"]
        }
        
        table[target].replace("]]","")
        return table[target].split("],[")
    }
    
    internal func GetGrade(num : Int) -> String
    {
        return ((num/100)/100).toString()
    }
    
    internal func GetClass(num: Int) -> String
    {
        return ((num/100) - Int((num/100)/100) * 100).toString()
    }
    
    internal func GetSubjectNmae(num:Int) -> String
    {
        let return_data = subject[num-(num/100)*100].replace("\"","").replace("NG","").replace(" ","").replace("SE","")
        if return_data == ""
        {
            return "정보없음"
        }
        else
        {
            return return_data
        }
    }
    
    internal func ConvertDays(num:Int) -> String
    {
        switch num
        {
        case 0: return "월요일"
        case 1: return "화요일"
        case 2: return "수요일"
        case 3: return "목요일"
        case 4: return "금요일"
        default: return "ERROR"
        }
    }
    
    static func ConvertDays(num:Int) -> String
    {
        switch num
        {
        case 0: return "월요일"
        case 1: return "화요일"
        case 2: return "수요일"
        case 3: return "목요일"
        case 4: return "금요일"
        default: return "ERROR"
        }
    }
}

    