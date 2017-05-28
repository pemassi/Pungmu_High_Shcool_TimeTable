//
//  MainViewController.swift
//  풍무고등학교
//
//  Created by 프매씨 on 2015. 10. 26..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import UIKit
class MainViewContorller: UIViewController {
    
    private var Load_Flag = false
    
    @IBOutlet weak var lb_class: UILabel!
    @IBOutlet weak var txt_status: UITextView!
    @IBOutlet weak var lb_day: UILabel!
    @IBOutlet weak var lb_weekday: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = NSDate()
        let fomatter = NSDateFormatter()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: today)
        let weekDay = myComponents.weekday - 2
        
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        
        fomatter.dateFormat = "YYYY년 MM월 dd일"
        lb_day.text = fomatter.stringFromDate(today)
        lb_weekday.text = TimeTable.ConvertDays(weekDay)
        
        txt_status.text = "로딩중"
        txt_status.font = UIFont.systemFontOfSize(14)
        txt_status.scrollRangeToVisible(NSMakeRange(0, 0))
        
        if User_Kind == 0
        {
            lb_class.text = "\(User_Grade)학년 \(User_Class)반"
        }
        else
        {
            lb_class.text = "\(User_Teacher_Name) 선생님"
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if Load_Flag == false
        {
            
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            
            let queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
            
            dispatch_async(queue){
                if (Reachability.isConnectedToNetwork() == true) && (User_Live_Update == true) && (User_Kind == 0)
                {
                    let live_timetable:TimeTable
                    
                    if let target_table = Share.instance.Table
                    {
                        live_timetable = target_table
                    }
                    else
                    {
                        Share.instance.Table = TimeTable(.Live)
                        live_timetable = Share.instance.Table!
                    }
                    
                    let unlive_timetable = TimeTable(.unLive)
                    
                    let live_table = live_timetable.GetTimetable(User_Grade, User_Class)
                    let unlive_table = unlive_timetable.GetTimetable(User_Grade, User_Class)
                    
                    if live_table[0] != "ERROR"
                    {
                        let today = NSDate()
                        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                        let myComponents = myCalendar.components(.Weekday, fromDate: today)
                        let weekDay = myComponents.weekday - 2
                       
                        var set_string:String = ""
                       
                        //토요일, 일요일 같은 경우 시간표에 없기 떄문에 예외처리
                        if (weekDay == -1) || (weekDay == 5)
                        {
                            set_string = "휴일"
                        }
                        else
                        {
                            var live_tables:[String] = live_table[weekDay].split(",")
                            var unlive_tables:[String] = unlive_table[weekDay].split(",")
                            for var j = 1; j<8; j++
                            {
                                if live_tables[j] != unlive_tables[j]
                                {
                                    set_string = set_string + "\(j)교시 수업이 " + String(unlive_timetable.GetSubjectNmae(Int(unlive_tables[j])!)) + "(" + unlive_timetable.GetTeacherName(Int(unlive_tables[j])!) + ")에서 " + String(live_timetable.GetSubjectNmae(Int(live_tables[j])!)) + "(" + live_timetable.GetTeacherName(Int(live_tables[j])!) + ")" + "으로 변경되었습니다.\n\n"
                                }
                            }
                        }
                        
                        if set_string == ""
                        {
                            self.chg_text("시간표 변동 사항이 없습니다.")
                        }
                        else if set_string == "휴일"
                        {
                            self.chg_text("오늘은 휴일 입니다.")
                        }
                        else
                        {
                            self.chg_text("오늘 시간표 변동 사항이 있습니다.\n\n" + set_string)
                        }
                        
                    }
                    else
                    {
                        self.chg_text("\(User_Grade)학년 \(User_Class)반은 없는 학급 입니다.\n\n학년 반을 재 설정해주세요.")
                    }
                    
                    
                }
                else if User_Kind == 1
                {
                    self.chg_text("오늘도 좋은 하루 되세요.")
                }
                else if User_Live_Update == false
                {
                    self.chg_text("라이브 업데이트 기능이 비활성화 되어 있습니다.")
                }
                else
                {
                    self.chg_text("오프라인 모드\n인터넷에 연결되어있지 않습니다.")
                }
                
                self.Load_Flag = true
                dispatch_async(dispatch_get_main_queue()){
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func chg_text(str:String)
    {
        dispatch_async(dispatch_get_main_queue()){
            self.txt_status.text = str
            self.txt_status.font = UIFont.systemFontOfSize(14)
            self.txt_status.scrollRangeToVisible(NSMakeRange(0, 0))
        }
    }
    
    
    
}
