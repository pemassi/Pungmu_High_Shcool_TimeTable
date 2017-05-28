//
//  FirstViewController.swift
//  Pungmu_Timetable
//
//  Created by 프매씨 on 2015. 10. 23..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//


import UIKit

class TimeTableViewController: UIViewController {

    @IBOutlet weak var txt_timetable: UITextView!
    @IBOutlet weak var sc_weekday: UISegmentedControl!
    @IBOutlet weak var lb_update: UILabel!
    @IBOutlet weak var navi_title: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var timetable:TimeTable?
    private var timetable_teacher:TimeTable_Teacher?
    private var Internet_Flag:Bool = false
    private var Load_Flag:Bool = false
    private var data_flag:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Internet_Flag = Reachability.isConnectedToNetwork()
        
        if (Internet_Flag == true) && (User_Live_Update == true)
        {
            lb_update.text = "업데이트 : 라이브"
        }
        else
        {
            if let update = Data_Save.stringForKey(Data_Key.Time_Update)
            {
                lb_update.text = "업데이트 : \(update)"
            }
            else
            {
                lb_update.text = "업데이트 : 정보가 없음"
                data_flag=false
            }
            
        }
        
        if (User_Kind==0)
        {
            navi_title.title = "\(User_Grade)학년 \(User_Class)반 시간표"
        }
        else
        {
            navi_title.title = User_Teacher_Name + " 선생님"
        }
        
        Chg_text("시간표 불러오는 중")
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        txt_timetable.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Left
        txt_timetable.addGestureRecognizer(swipeDown)
        
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    
    override func viewDidAppear(animated:Bool)
    {
        super.viewDidAppear(animated)
        
        if Load_Flag == false
        {
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()

            let queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
            
            dispatch_async(queue){
                
                if (self.Internet_Flag == true) && (User_Live_Update == true) && (User_Kind == 0)
                {
                    if let target = Share.instance.Table
                    {
                        self.timetable = target
                    }
                    else
                    {
                        self.timetable = TimeTable(.Live)
                    }
                }
                else if (self.Internet_Flag == true) && (User_Kind == 1)
                {
                    if let target = Share.instance.Table_Teacher
                    {
                        self.timetable_teacher = target
                    }
                    else
                    {
                        self.timetable_teacher = TimeTable_Teacher(.Live)
                    }
                }
                else
                {
                    self.timetable = TimeTable(.unLive)
                }
                
                let today = NSDate()
                let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                let myComponents = myCalendar.components(.Weekday, fromDate: today)
                let weekDay = myComponents.weekday - 2
                
                if (weekDay == -1) || (weekDay == 5)
                {
                    self.sc_weekday.selectedSegmentIndex = 0
                }
                else
                {
                    self.sc_weekday.selectedSegmentIndex = weekDay
                }
                self.sc_day_changed(self.sc_weekday)
                
                dispatch_async(dispatch_get_main_queue()){
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                }
            }
        }
    
        
        
    }
    
    private func Chg_text(str:String)
    {
        dispatch_async(dispatch_get_main_queue()){
            self.txt_timetable.text = str
            self.txt_timetable.font = UIFont.systemFontOfSize(20)
            self.txt_timetable.textAlignment = .Center
            self.txt_timetable.scrollRangeToVisible(NSMakeRange(0, 0))
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                if sc_weekday.selectedSegmentIndex != 0
                {
                    sc_weekday.selectedSegmentIndex = sc_weekday.selectedSegmentIndex - 1
                    sc_day_changed(sc_weekday)
                }
            case UISwipeGestureRecognizerDirection.Right:
                if sc_weekday.selectedSegmentIndex != 5
                {
                    sc_weekday.selectedSegmentIndex = sc_weekday.selectedSegmentIndex + 1
                    sc_day_changed(sc_weekday)
                }
            default:
                break
            }
        }
    }

    @IBAction func sc_day_changed(sender: UISegmentedControl) {
        
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        let queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
        
        dispatch_async(queue){
            
            let weekDay = sender.selectedSegmentIndex
            
            if (User_Kind == 0)
            {
                let table = self.timetable!.GetTimetable(User_Grade, User_Class)
            
                if table[0] == "ERROR"
                {
                    self.Chg_text("\(User_Grade)학년 \(User_Class)반은 없는 학급 입니다.\n\n학년 반을 재설정 해주세요.")
                }
                else if self.data_flag == true
                {
                   
                    var set_string:String = ""
                    var tables:[String] = table[weekDay].split(",")
                    for var j = 1; j<8; j++
                    {
                        set_string = set_string + "\(j)교시 : " + String(self.timetable!.GetSubjectNmae(Int(tables[j])!) + "(" + self.timetable!.GetTeacherName(Int(tables[j])!) + ")")
                        if(j < 7)
                        {
                            set_string = set_string + "\n\n"
                        }
                    }
                    self.Chg_text(set_string)
                }
                else
                {
                    self.Chg_text("저장된 시간표가 없습니다\n\n설정에서 시간표를 업데이트 해주세요.")
                }
            }
            else
            {
                let table = self.timetable_teacher!.GetTimetable(User_Teacher_Code)
                if table[0] == "ERROR"
                {
                    self.Chg_text("선생님 코드가 변경되었거나 없는 선생님 입니다.")
                }
                else if self.data_flag == true
                {
                    var set_string:String = ""
                    var tables:[String] = table[weekDay].split(",")
                    for var j = 1; j<8; j++
                    {
                        let target_code = Int(tables[j])!
                        let subject = self.timetable_teacher!.GetSubjectNmae(target_code)
                        let grade = self.timetable_teacher!.GetGrade(target_code)
                        let classs = self.timetable_teacher!.GetClass(target_code)
                        
                        set_string = set_string + "\(j)교시 : \(subject) (\(grade)학년 \(classs)반)\n\n"
                    }
                    self.Chg_text(set_string)
                }
                else
                {
                    self.Chg_text("선생님 시간표는 반드시 인터넷 연결이 필요합니다.")
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

