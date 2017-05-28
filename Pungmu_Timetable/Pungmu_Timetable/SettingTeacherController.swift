//
//  SettingTeacherController.swift
//  풍무고등학교
//
//  Created by 프매씨 on 2015. 11. 5..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import UIKit

class SettingTeacherController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var pv_teacher: UIPickerView!
    
    private var selected_item:Int = 0
    let timetable = TimeTable_Teacher(.Live)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        pv_teacher.delegate = self
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    
    @IBAction func btn_back(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func btn_next(sender: AnyObject) {
        
        if selected_item == 0
        {
            let toast = MessageBox(View: self, Subject: "오류", Body: "선생님의 이름을 선택해주세요!")
            toast.Show()
            
        }
        else
        {
            let toast = MessageBox(View: self, Subject: "확인", Body: "\(timetable.teacher[selected_item]) 선생님 맞으세요?")
            let ui = UIAlertAction(title: "네", style: .Default) {
                UIAlertAction in
                
                dispatch_async(dispatch_get_main_queue()){
                    User_Teacher_Code = self.selected_item
                    User_Teacher_Name = self.timetable.teacher[self.selected_item].replace("\"","")
                    Data_Save.setValue(self.selected_item,forKey: Data_Key.Setting_Teacher_Code)
                    Data_Save.setValue(self.timetable.teacher[self.selected_item].replace("\"",""),forKey: Data_Key.Setting_Teacher_Name)
                    Data_Save.synchronize()
                    
                    
                    self.reset_home()
                }
            }
            toast.addAction(ui)
            toast.addAction("아니요", style: .Cancel)
            toast.Show()
        }
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timetable.teacher.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0
        {
            return "선택해주세요"
        }
        return timetable.teacher[row].replace("\"","")
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected_item = row
    }
    
}
