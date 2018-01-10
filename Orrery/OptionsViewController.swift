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
    func didUpdateDate(newDate:NSDate) -> Bool
}

class OptionsViewController: NSViewController {
    @IBOutlet weak var animationSpeedSlider: NSSliderCell?
    @IBOutlet weak var datePicker: NSDatePickerCell?
    @IBOutlet weak var sliderLabel: NSTextField?
    
    weak var delegate:OptionsViewControllerDelegate?
    var date:NSDate = NSDate()
    
    override func viewDidLoad() {
        datePicker?.dateValue = Date.init(timeIntervalSinceNow: date.timeIntervalSinceNow)
    }
    
    @IBAction func sliderDidUpdate(sender:NSSlider) {
        sliderLabel?.stringValue = descriptiveLabel(num: sender.doubleValue)
        delegate?.didUpdateSlider(sliderValue: sender.doubleValue)
    }
    
    @IBAction func changeDate(sender:NSDatePicker) {
        //TODO: fix render time
        datePicker?.isEnabled = false
        let oldDate = date
        date = NSDate(timeIntervalSinceNow: sender.dateValue.timeIntervalSinceNow)
        let success = delegate?.didUpdateDate(newDate: date)
        if success == false {
            date = oldDate
            datePicker?.dateValue = Date.init(timeIntervalSinceNow: date.timeIntervalSinceNow)
        } else {
            datePicker?.isEnabled = true
        }
    }
    
    func descriptiveLabel(num:Double) -> String {
        var labelName:String
        switch num {
        case 0:
            labelName = "<--1 Second-->"
        case 25:
            labelName = "week per second"
        case 50:
            labelName = "month per second"
        case 75:
           labelName = "year per second"
        case 100:
            labelName = "10 years per second"
        case -25:
            labelName = "-week per second"
        case -50:
            labelName = "-month per second"
        case -75:
            labelName = "-year per second"
        case -100:
            labelName = "-10 years per second"
        default:
            labelName = "<--1 Second-->"
        }
        return labelName
    }
}
