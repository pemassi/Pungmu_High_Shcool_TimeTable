//
//  SettingViewController.swift
//  풍무고등학교
//
//  Created by 프매씨 on 2015. 10. 28..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import UIKit

class SettingViewController:UITableViewController
{
    
    @IBOutlet weak var lb_tableupdate: UILabel!
    @IBOutlet weak var sw_liveupdate: UISwitch!
    @IBOutlet weak var lb_invidual: UILabel!
    @IBOutlet weak var lb_var: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        lb_var.text = "V " + version
        
        if User_Kind == 0
        {
            lb_invidual.text = "\(User_Grade)학년 \(User_Class)반"
        }
        else
        {
            lb_invidual.text = "\(User_Teacher_Name)선생님 (\(User_Teacher_Code))"
        }
        
        if let update = Data_Save.stringForKey(Data_Key.Time_Update)
        {
            lb_tableupdate.text = update
        }
        else
        {
            lb_tableupdate.text = "정보가 없습니다."
        }
        
        if let liveupdate = Data_Save.stringForKey(Data_Key.Setting_LiveUpdate)
        {
            if Int(liveupdate) == 0
            {
                sw_liveupdate.on = false
            }
            else
            {
                sw_liveupdate.on = true
            }
        }
        
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        
        switch indexPath.section
        {
            case 0: break
            
            case 1: break
            
            case 2:
                
                let toast = MessageBox(View: self, Subject: "정보 초기화 확인", Body: "정말로 정보를 초기화 하시겠습니까?")
                let ui = UIAlertAction(title: "네", style: .Destructive) {
                    UIAlertAction in
                    
                    self.reset_really()
                    
                }
                toast.addAction(ui)
                toast.addAction("아니요", style: .Cancel)
                toast.Show()
            
                break
            
            case 3: break
            
            default: break
        }
        
       // super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    func reset_really()
    {
        let toast = MessageBox(View: self, Subject: "정보 초기화 다시 확인", Body: "정말로 정보를 초기화 하시겠습니까?")
        toast.addAction("아니요", style: .Cancel)
        let ui = UIAlertAction(title: "네", style: .Destructive) {
            UIAlertAction in
            
            for key in Data_Save.dictionaryRepresentation().keys {
                Data_Save.removeObjectForKey(key)
                //print(key)
            }
            
            self.go_home()

            
        }
        toast.addAction(ui)
        toast.Show()
    }
    
    func go_home()
    {
        
        let toast = MessageBox(View: self, Subject: "초기화 완료", Body: "초기화 완료.\n\n어플을 다시시작 합니다.")
        let ui = UIAlertAction(title: "확인", style: .Default) {
            UIAlertAction in
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Lunch") as! LunchViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        toast.addAction(ui)
        toast.Show()
    }
    
    @IBAction func sc_liveupdate_valuechanged(sender:UISwitch)
    {
        
        let liveupdate_bool:Int
        if sw_liveupdate.on == true
        {
            liveupdate_bool = 1
            User_Live_Update = true
        }
        else
        {
            liveupdate_bool = 0
            User_Live_Update = false
        }
        Data_Save.setValue(liveupdate_bool, forKey: Data_Key.Setting_LiveUpdate)
        Data_Save.synchronize()
    }
    
    @IBAction func btn_edit_invidual(sender: AnyObject) {
        
        if User_Kind == 0
        {
            let switchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("editClassSetting") as! SettingClassViewController
            self.navigationController?.pushViewController(switchViewController, animated: true)
        }
        else
        {
            let switchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("editTeacherSetting") as! SettingTeacherController
            self.navigationController?.pushViewController(switchViewController, animated: true)
        }
        
    }
    @IBAction func btn_update_clicked(sender: AnyObject) {
        
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        let queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
        
        dispatch_async(queue){
         
            if Reachability.isConnectedToNetwork() == true
            {
                Share.instance.Table = TimeTable(.Live)
                
                let today = NSDate()
                let dateFormat = NSDateFormatter()
                dateFormat.dateFormat = "YYYY/MM/dd"
                
                let now_year = dateFormat.stringFromDate(today).split("/")[0]
                let now_month = dateFormat.stringFromDate(today).split("/")[1]
                Meal.StrongUpDate(now_year.toInt(),now_month.toInt())
                
                if let update = Data_Save.stringForKey(Data_Key.Time_Update)
                {
                    dispatch_async(dispatch_get_main_queue()){
                        self.lb_tableupdate.text = update
                    }
                    let toast = MessageBox(View: self, Subject: "업데이트 완료", Body: "\(update) 일자 시간표/급식표로 업데이트 되었습니다.")
                    toast.Show()
                }
                else
                {
                    let toast = MessageBox(View: self, Subject: "업데이트 실패", Body: "알수 없는 이유로 시간표/급식표 업데이트를 실패하였습니다.")
                    toast.Show()
                    //lb_tableupdate.text = "정보가 없습니다."
                }
            }
            else
            {
                let toast = MessageBox(View: self, Subject: "오프라인 모드", Body: "인터넷에 연결이 되어있지 않아 업데이트를 진행할 수 없습니다.")
                toast.Show()
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            }
            
        }
        
    }
    
}
