//
//  KindSettingController.swift
//  풍무고등학교
//
//  Created by 프매씨 on 2015. 11. 5..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import UIKit

class KindSettingController:UIViewController
{
    @IBOutlet weak var sc_kind: UISegmentedControl!
 
    @IBAction func btn_next(sender: AnyObject) {
    
        if sc_kind.selectedSegmentIndex == 0
        {
            let switchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("newClassSetting") as! NewSettingController
            self.navigationController?.pushViewController(switchViewController, animated: true)
        }
        else
        {
            if Reachability.isConnectedToNetwork() == true
            {
                let switchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TeacherSetting") as! TeacherSettingController
                self.navigationController?.pushViewController(switchViewController, animated: true)
            }
            else
            {
                let toast = MessageBox(View: self, Subject: "오프라인", Body: "인터넷에 연결이 되어있어지 않아 설정을 진행할 수 없습니다.")
                toast.Show()
            }
            
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()){
            User_Kind = self.sc_kind.selectedSegmentIndex
            Data_Save.setValue(self.sc_kind.selectedSegmentIndex.toString(),forKey:Data_Key.Setting_About)
            Data_Save.synchronize()
        }
    }
}