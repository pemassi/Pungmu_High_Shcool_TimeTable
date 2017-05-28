//
//  SecondViewController.swift
//  Pungmu_Timetable
//
//  Created by 프매씨 on 2015. 10. 23..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import UIKit

class MealViewController: UIViewController {

    @IBOutlet weak var txt_test: UITextView!
    @IBOutlet weak var txt_date: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let swipeRec = UISwipeGestureRecognizer()
    let dateFormatter = NSDateFormatter()
    var chk_online:Bool = false
    let today = NSDate()

    var meal:Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 EEEE"
        dateFormatter.locale = NSLocale(localeIdentifier: "ko-kr")
        
        txt_date.text = dateFormatter.stringFromDate(today)
     
        txt_test.text = "급식표 불러오는 중"
        txt_test.font = UIFont.systemFontOfSize(16)
        txt_test.textAlignment = .Center
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        txt_test.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Left
        txt_test.addGestureRecognizer(swipeDown)
       
        updatemeal(today)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                btn_pri_clicked(self)
            case UISwipeGestureRecognizerDirection.Right:
                btn_next_clicked(self)
            default:
                break
            }
        }
    }
    
    override func viewDidAppear(animated:Bool){
        super.viewDidAppear(animated)
        
        txt_test.scrollRangeToVisible(NSMakeRange(0, 0))
        chk_online = Reachability.isConnectedToNetwork()
        
    }
    
    @IBAction func txt_date_BeginEditing(sender: UITextField) {
        //Create the view
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 EEEE"
        datePickerView.date = dateFormatter.dateFromString(txt_date.text!)!
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        doneButton.setTitle("완료", forState: UIControlState.Normal)
        doneButton.setTitle("완료", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: "doneButton:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView) // Set the date on start.
        txt_test.font = UIFont.systemFontOfSize(16)
        txt_test.textAlignment = .Center
    }
    
    @IBAction func btn_pri_clicked(sender: AnyObject) {
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 EEEE"
        let targetDay:NSDate = dateFormatter.dateFromString(txt_date.text!)!
        
        let ns:NSDateComponents = NSDateComponents()
        ns.day = -1
        let nc:NSCalendar = NSCalendar.currentCalendar()
        let nd:NSDate = nc.dateByAddingComponents(ns, toDate: targetDay, options: .MatchFirst)!
        
        dateFormatter.dateFormat = "MM"
        
        if (chk_online == true) && (User_Live_Update == true)
        {
            updatemeal(nd)
        }
        else
        {
            if dateFormatter.stringFromDate(nd) == dateFormatter.stringFromDate(today)
            {
                updatemeal(nd)
            }
            else
            {
                let toast = MessageBox(View: self, Subject: "오프리인 모드", Body: "이번 달 급식정보만 확인할 수 있습니다.")
                toast.Show()
            }
        }
    }
    
    @IBAction func btn_today_clicked(sender: AnyObject) {
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 EEEE"
        dateFormatter.locale = NSLocale(localeIdentifier: "ko-kr")
        updatemeal(today)
    }
    
    @IBAction func btn_next_clicked(sender: AnyObject) {
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 EEEE"
        let targetDay:NSDate = dateFormatter.dateFromString(txt_date.text!)!
        
        let ns:NSDateComponents = NSDateComponents()
        ns.day = 1
        let nc:NSCalendar = NSCalendar.currentCalendar()
        let nd:NSDate = nc.dateByAddingComponents(ns, toDate: targetDay, options: .MatchFirst)!
        
        dateFormatter.dateFormat = "MM"
        
        if (chk_online == true) && (User_Live_Update == true)
        {
            updatemeal(nd)
        }
        else
        {
            if dateFormatter.stringFromDate(nd) == dateFormatter.stringFromDate(today)
            {
                updatemeal(nd)
            }
            else
            {
                let toast = MessageBox(View: self, Subject: "오프리인 모드", Body: "이번 달 급식정보만 확인할 수 있습니다.")
                toast.Show()
            }
        }
    }
    
    func updatemeal(targetDay:NSDate)
    {
        
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 EEEE"
        let nowDay = dateFormatter.dateFromString(txt_date.text!)!
        txt_date.text = dateFormatter.stringFromDate(targetDay)
        
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let now_year = dateFormatter.stringFromDate(targetDay).split("/")[0]
        let now_month = dateFormatter.stringFromDate(targetDay).split("/")[1]
        let now_day = dateFormatter.stringFromDate(targetDay).split("/")[2]
        
        dispatch_async(dispatch_get_main_queue()){
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
        }
        
        Chg_text("급식표 불러오는 중")
        
        let queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
        
        dispatch_async(queue){
            
            if self.dateFormatter.stringFromDate(targetDay) != self.dateFormatter.stringFromDate(nowDay)
            {
                if (self.chk_online == true) && (User_Live_Update == true)
                {
                    self.meal = Meal(now_year.toInt(),now_month.toInt(),Meal.Mode.Live)
                }
                else
                {
                    self.meal = Meal(now_year.toInt(),now_month.toInt(),Meal.Mode.unLive)
                }
                
            }
            else
            {
                self.meal = Meal(now_year.toInt(),now_month.toInt(),Meal.Mode.unLive)
            }

            if self.meal?.List.count == 1
            {
                if self.meal?.error == Meal.Error.NoData
                {
                    self.Chg_text("저장된 급식정보가 없습니다.\n\n설정에서 급식표를 업데이트 해주세요.")
                    self.txt_date.userInteractionEnabled = false
                }
                else if self.meal!.error == Meal.Error.NeedUpdate
                {
                    self.Chg_text("저장된 급식정보의 유효기간이 지났습니다.\n\n설정에서 급식표를 업데이트 해주세요.")
                    self.txt_date.userInteractionEnabled = false
                }
            }
            else if self.meal?.List.count < now_day.toInt()
            {
                self.Chg_text("저장된 급식정보에 문제가 있습니다.\n수동으로 설정에서 업데이트를 해주세요.")
            }
            else
            {
                self.Chg_text((self.meal?.List[now_day.toInt()].replace("[석식]","\n\n[석식]"))!)
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            }
            
        }
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 EEEE"
        let targetDay:NSDate = sender.date
        
        dateFormatter.dateFormat = "MM"
        
        if (chk_online == true) && (User_Live_Update == true)
        {
            updatemeal(targetDay)
        }
        else
        {
            if dateFormatter.stringFromDate(targetDay) == dateFormatter.stringFromDate(today)
            {
                updatemeal(targetDay)
            }
            else
            {
                let toast = MessageBox(View: self, Subject: "오프리인 모드", Body: "이번 달 급식정보만 확인할 수 있습니다.")
                toast.Show()
            }
        }
    }
    
    func Chg_text(str:String)
    {
        dispatch_async(dispatch_get_main_queue()){
            self.txt_test.text = str
            self.txt_test.font = UIFont.systemFontOfSize(16)
            self.txt_test.textAlignment = .Center
            self.txt_test.scrollRangeToVisible(NSMakeRange(0, 0))
        }
    }
    
    func doneButton(sender:UIButton)
    {
        txt_date.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

