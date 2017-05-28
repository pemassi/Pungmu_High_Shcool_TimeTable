//
//  TodayViewController.swift
//  notify
//
//  Created by 프매씨 on 2015. 10. 26..
//  Copyright © 2015년 김경윤(프매씨). All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var lb_main: UILabel!
    @IBOutlet weak var sc_selected: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        print("?")
        
        let today = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "YYYY년 MM월 dd일 급식표"
        lb_date.text = dateFormat.stringFromDate(today)
        
        dateFormat.dateFormat = "HH"
        if (dateFormat.stringFromDate(today).toInt() < 13 || dateFormat.stringFromDate(today).toInt() > 19)
        {
            sc_selected.selectedSegmentIndex = 0
            sc_selected_clicked(self)
        }
        else
        {
            sc_selected.selectedSegmentIndex = 1
            sc_selected_clicked(self)
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let today = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "YYYY년 MM월 dd일 급식표"
        if lb_date.text != dateFormat.stringFromDate(today)
        {
            viewDidLoad()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            return UIEdgeInsetsZero
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        let today = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "YYYY년 MM월 dd일 급식표"
        if lb_date.text != dateFormat.stringFromDate(today)
        {
            viewDidLoad()
            completionHandler(NCUpdateResult.NewData)
        }
        else
        {
            completionHandler(NCUpdateResult.NoData)
        }

    }
    @IBAction func sc_selected_clicked(sender: AnyObject) {
        
        let today = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "YYYY/MM/dd"
        
        let now_month = dateFormat.stringFromDate(today).split("/")[1]
        let now_year = dateFormat.stringFromDate(today).split("/")[0]
        let now_day = dateFormat.stringFromDate(today).split("/")[2]
        let meal:Meal
       
        meal = Meal(Int(now_year)!,Int(now_month)!,Meal.Mode.unLive)
        
        Chg_text("로딩 중", lb_date.text!)
        
        if meal.List.count == 1
        {
            if meal.error == Meal.Error.NoData
            {
                Chg_text("저장된 급식정보가 없습니다.\n\n\n어플을 실행해 업데이트 해주세요.","")
            }
            else if meal.error == Meal.Error.NeedUpdate
            {
                Chg_text("저장된 급식정보의 유효기간이 지났습니다.\n\n\n어플을 실행해 업데이트 해주세요.","")
            }
        }
        else if meal.List.count < now_day.toInt()
        {
            Chg_text("저장된 급식정보에 문제가 있습니다.\n수동으로 설정에서 업데이트를 해주세요.","")
        }
        else if sc_selected.selectedSegmentIndex == 0
        {
            dateFormat.dateFormat = "YYYY년 MM월 dd일 급식표"
            Chg_text("\n" + meal.Lunch[now_day.toInt()], dateFormat.stringFromDate(today))
        }
        else
        {
            dateFormat.dateFormat = "YYYY년 MM월 dd일 급식표"
            Chg_text(meal.Dinner[now_day.toInt()], dateFormat.stringFromDate(today))
        }
        
    }
    
    func Chg_text(str:String,_ str2:String)
    {
        dispatch_async(dispatch_get_main_queue()){
            self.lb_main.text = str
            self.lb_date.text = str2
        }
    }
}
