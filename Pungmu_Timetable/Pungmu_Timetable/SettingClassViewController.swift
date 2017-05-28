//
//  SettingClassViewController.swift
//  풍무고등학교
//
//  Created by 프매씨 on 2015. 10. 28..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import UIKit

class SettingClassViewController:UIViewController
{
    @IBOutlet weak var txt_grade: UITextField!
    @IBOutlet weak var txt_class: UITextField!
    @IBOutlet weak var sp_grade: UIStepper!
    @IBOutlet weak var sp_class: UIStepper!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sp_grade.wraps = true
        sp_grade.autorepeat = true
        sp_grade.minimumValue = 1
        sp_grade.maximumValue = 3
        sp_grade.value = Double(User_Grade)
        txt_grade.text = User_Grade.toString()
        
        sp_class.wraps = true
        sp_class.autorepeat = true
        sp_class.minimumValue = 1
        sp_class.maximumValue = 100
        sp_class.value = Double(User_Class)
        txt_class.text = User_Class.toString()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
    }
    
    @IBAction func sp_garde_changed(sender: UIStepper) {
        txt_grade.text = Int(sender.value).description
    }
    
    @IBAction func sp_class_changed(sender: UIStepper) {
        txt_class.text = Int(sender.value).description
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        btn_finished_clicked(self)
    }
    @IBAction func btn_back(sender: AnyObject) {
        
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func btn_finished_clicked(sender: AnyObject) {
        
        
        let toast = MessageBox(View: self, Subject: "확인", Body: "\(Int(sp_grade.value))학년 \(Int(sp_class.value))반 학생이 맞으신가요?")
        let ui = UIAlertAction(title: "네", style: .Default) {
            UIAlertAction in
            
            dispatch_async(dispatch_get_main_queue()){
                
                Data_Save.setValue(Int(self.sp_grade.value), forKey: Data_Key.Data_Grade)
                Data_Save.setValue(Int(self.sp_class.value), forKey: Data_Key.Data_Class)
                Data_Save.synchronize()
                
                User_Grade = Int(self.sp_grade.value)
                User_Class = Int(self.sp_class.value)
                
                
                self.reset_home()
            }
        }
        toast.addAction(ui)
        toast.addAction("아니요", style: .Cancel)
        toast.Show()
        
       
    }
    
    func reset_home()
    {
        let toast = MessageBox(View: self, Subject: "저장 완료", Body: "어플을 다시 시작 합니다.")
        let ui = UIAlertAction(title: "확인", style: .Default) {
            UIAlertAction in
            
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Lunch") as! LunchViewController
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
        toast.addAction(ui)
        toast.Show()
    }
    
}
