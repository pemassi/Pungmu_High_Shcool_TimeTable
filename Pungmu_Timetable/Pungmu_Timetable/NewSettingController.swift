//
//  NewSettingController.swift
//  풍무고등학교
//
//  Created by 프매씨 on 2015. 10. 28..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import UIKit

class NewSettingController: UIViewController {
    
    @IBOutlet weak var txt_grade: UITextField!
    @IBOutlet weak var txt_class: UITextField!
    @IBOutlet weak var sp_grade: UIStepper!
    @IBOutlet weak var sp_class: UIStepper!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sp_grade.wraps = true
        sp_grade.autorepeat = true
        sp_grade.maximumValue = 3
        sp_grade.minimumValue = 1
        sp_grade.value = 1
        
        sp_class.wraps = true
        sp_class.autorepeat = true
        sp_class.maximumValue = 100
        sp_class.minimumValue = 1
        sp_class.value = 1
    }
    
    @IBAction func sp_garde_changed(sender: UIStepper) {
        txt_grade.text = Int(sender.value).description
    }
    
    @IBAction func sp_class_changed(sender: UIStepper) {
        txt_class.text = Int(sender.value).description
    }
    
    @IBAction func btn_finished_clicked(sender: AnyObject) {
       
        Data_Save.setValue(Int(sp_grade.value), forKey: Data_Key.Data_Grade)
        Data_Save.setValue(Int(sp_class.value), forKey: Data_Key.Data_Class)
        Data_Save.synchronize()
        
        User_Grade = Int(sp_grade.value)
        User_Class = Int(sp_class.value)
        
    }

}
