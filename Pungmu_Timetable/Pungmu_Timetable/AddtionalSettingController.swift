//
//  AddtionalSettingController.swift
//  풍무고등학교
//
//  Created by 프매씨 on 2015. 10. 30..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import UIKit

class AddtionalSettingController: UIViewController
{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sw_liveupdate: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    @IBAction func btn_finished_clicked(sender: AnyObject) {
        
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
        
        if sw_liveupdate.on == false
        {
            let toast = MessageBox(View: self, Subject: "라이브 업데이트 비활성화", Body: "라이브 업데이트 기능을 사용하지 않을 경우 수동으로 업데이트를 하셔야 합니다. 정말로 라이브 업데이트 기능을 사용하지 않으시겠습니까?")
            let ui = UIAlertAction(title: "네", style: .Default) {
                UIAlertAction in
                
                self.next_step()
            }
            toast.addAction(ui)
            toast.addAction("아니요", style: .Cancel)
            toast.Show()
        }
        else if Reachability.isConnectedToNetwork() == false
        {
            let toast = MessageBox(View: self, Subject: "오프라인 상태", Body: "현재 인터넷에 연결되어있지 않아 최초 시간표/급식표 업데이트에 실패하였습니다.\n\n추후에 인터넷과 연결된 상태에서 업데이트를 해주세요.")
            let ui = UIAlertAction(title: "확인", style: .Default) {
                UIAlertAction in
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MainTab") as! UITabBarController
                self.presentViewController(vc, animated: true, completion: nil)
            }
            toast.addAction(ui)
            toast.Show()

        }
        else
        {
            next_step()
        }
    }
    
    private func next_step()
    {
        Data_Save.setInteger(1, forKey: Data_Key.Setting_Finish)
        Data_Save.synchronize()
        
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        let queue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
        dispatch_async(queue){
            
            let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            
            dispatch_async(dispatch_get_main_queue()){
                
                if User_Kind == 0
                {
                    Share.instance.Table = TimeTable(.Live)
                }
                
                let today = NSDate()
                let dateFormat = NSDateFormatter()
                dateFormat.dateFormat = "YYYY/MM"
                
                let now_year = dateFormat.stringFromDate(today).split("/")[0]
                let now_month = dateFormat.stringFromDate(today).split("/")[1]
                
                Meal.UpDate(now_year.toInt(),now_month.toInt())
                
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MainTab") as! UITabBarController
                self.presentViewController(vc, animated: true, completion: nil)
            }
        
        }
    }
    
}