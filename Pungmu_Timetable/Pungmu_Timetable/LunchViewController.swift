//
//  LunchViewController.swift
//  풍무고등학교
//
//  Created by 프매씨 on 2015. 10. 28..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import UIKit

class LunchViewController: UIViewController {
    
    private var signalOnceToken = dispatch_once_t()
    
    @IBOutlet weak var lb_status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        update_status("사용자 설정 불러오는 중")
        
        let queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
        
        dispatch_async(queue){
            
            if let _ = Data_Save.stringForKey(Data_Key.Setting_Finish)
            {
                // 사용자 읽어오기
                User_Kind = Data_Save.stringForKey(Data_Key.Setting_About)!.toInt()
                if User_Kind == 0
                {
                    User_Grade = Data_Save.stringForKey(Data_Key.Data_Grade)!.toInt()
                    User_Class = Data_Save.stringForKey(Data_Key.Data_Class)!.toInt()
                }
                else
                {
                    User_Teacher_Code = Data_Save.stringForKey(Data_Key.Setting_Teacher_Code)!.toInt()
                    User_Teacher_Name = Data_Save.stringForKey(Data_Key.Setting_Teacher_Name)!
                }
                
                // 라이브 업데이트 사용 여부
                if let liveupdate = Data_Save.stringForKey(Data_Key.Setting_LiveUpdate)
                {
                    if Int(liveupdate) == 0
                    {
                        User_Live_Update = false
                    }
                    else
                    {
                        User_Live_Update = true
                    }
                }
                if (Reachability.isConnectedToNetwork() == true) && (User_Live_Update == true)
                {
                    self.update_status("시간표 업데이트 중")
                    if User_Kind == 0
                    {
                        Share.instance.Table = TimeTable(.Live)
                    }
                    else
                    {
                        Share.instance.Table_Teacher = TimeTable_Teacher(.Live)
                    }
                    let today = NSDate()
                    let dateFormat = NSDateFormatter()
                    dateFormat.dateFormat = "YYYY/MM"
                    
                    let now_year = dateFormat.stringFromDate(today).split("/")[0]
                    let now_month = dateFormat.stringFromDate(today).split("/")[1]
                    
                    self.update_status("급식표 업데이트 중")
                    Meal.UpDate(now_year.toInt(),now_month.toInt())
                }
                else
                {
                    var update_flag:Bool = false
                    let todays = NSDate()
                    let dateFormat = NSDateFormatter()
                    dateFormat.dateFormat = "YYYY/MM"
                    
                    if let date = Data_Save.stringForKey(Data_Key.Meal_Update)
                    {
                        if date != dateFormat.stringFromDate(todays)
                        {
                            update_flag = true
                        }
                    }
                    
                    if update_flag == true
                    {
                        let toast = MessageBox(View: self, Subject: "업데이트 필요", Body: "저장된 급식표의 유효기간이 지났습니다\n\n설정에서 업데이트를 해주세요.")
                        let ui = UIAlertAction(title: "확인", style: .Default) {
                            UIAlertAction in
                            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MainTab") as! UITabBarController
                            self.presentViewController(vc, animated: true, completion: nil)
                        }
                        toast.addAction(ui)
                        toast.Show()
                    }
                }
                
                self.update_status("")
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MainTab") as! UITabBarController
                self.presentViewController(vc, animated: true, completion: nil)
                
            }
            else
            {
                self.update_status("")
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Welcome") as! UINavigationController
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update_status(text:String)
    {
        dispatch_async(dispatch_get_main_queue()){
            self.lb_status.text = text
        }
    }
}
