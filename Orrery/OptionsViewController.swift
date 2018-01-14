//
//  OptionsViewController.swift
//  Orrery
//
//  Created by Michael Golden on 1/9/18.
//  Copyright © 2018 norobostudios. All rights reserved.
//

import Foundation

protocol OptionsViewControllerDelegate: class {
    func didUpdateSlider(sliderValue:Double)
    func didUpdateDate(newDate:NSDate)
}

class OptionsViewController: NSViewController {
    
    // MARK: - Properties
    @IBOutlet weak var animationSpeedSlider: NSSliderCell?
    @IBOutlet weak var datePicker: NSDatePickerCell?
    @IBOutlet weak var sliderLabel: NSTextField?
    
    weak var delegate:OptionsViewControllerDelegate?
    var date:NSDate = NSDate()
    
    override func viewDidLoad() {
        datePicker?.dateValue = Date.init(timeIntervalSinceNow: date.timeIntervalSinceNow)
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"DateChangeNotification"),
                       object:nil, queue:nil, using:updateDate)
    }
    
    // MARK: - IBActions
    
    @IBAction func sliderDidUpdate(sender:NSSlider) {
        sliderLabel?.stringValue = descriptiveLabel(num: sender.doubleValue)
        delegate?.didUpdateSlider(sliderValue: sender.doubleValue)
    }
    
    @IBAction func changeDate(sender:NSDatePicker) {
        //TODO: fix render time
        datePicker?.isEnabled = false
        date = NSDate(timeIntervalSinceNow: sender.dateValue.timeIntervalSinceNow)
        delegate?.didUpdateDate(newDate: date)
        datePicker?.isEnabled = true
    }
 
    func updateDate(notification:Notification) -> Void {
        
        guard let userInfo = notification.userInfo,
            let date = userInfo["date"] as? NSDate else {
                print("No date found in notification")
                return
        }
        datePicker?.dateValue = Date(timeIntervalSinceNow:date.timeIntervalSinceNow)
    }
    
    // MARK: - Helper Fuction
    
    func descriptiveLabel(num:Double) -> String {
        var labelName:String
        switch num {
        case 0:
            labelName = "<--Static-->"
        case 25:
            labelName = "week per step"
        case 50:
            labelName = "month per step"
        case 75:
           labelName = "year per step"
        case 100:
            labelName = "10 years per step"
        case -25:
            labelName = "-week per step"
        case -50:
            labelName = "-month per step"
        case -75:
            labelName = "-year per step"
        case -100:
            labelName = "-10 years per step"
        default:
            labelName = "<--Static-->"
        }
        return labelName
    }
}
