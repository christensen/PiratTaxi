//
//  SettingsViewController.swift
//  PiratTaxi
//
//  Created by Jens Christensen on 2017-02-26.
//  Copyright © 2017 Christensen Software. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var startPriceTextBox: UITextField!
    @IBOutlet weak var hourPriceTextBox: UITextField!
    @IBOutlet weak var distancePriceTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPriceTextBox.placeholder = String(describing: UserDefaults.standard.value(forKey: "startPrice")!)
        hourPriceTextBox.placeholder = String(describing: UserDefaults.standard.value(forKey: "hourPrice")!)
        distancePriceTextBox.placeholder = String(describing: UserDefaults.standard.value(forKey: "distancePrice")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // Do any additional setup after loading the view.
    @IBAction func SaveButton(_ sender: Any) {
        let startPrice = Int(startPriceTextBox.text!)
        let hourPrice = Int(hourPriceTextBox.text!)
        let distancePrice = Int(distancePriceTextBox.text!)
        if startPrice != nil {
            UserDefaults.standard.setValue(startPrice, forKey: "startPrice")
        }
        if hourPrice != nil {
            UserDefaults.standard.setValue(hourPrice, forKey: "hourPrice")
        }
        if distancePrice != nil {
            UserDefaults.standard.setValue(distancePrice, forKey: "distancePrice")
        }
        self.dismiss(animated: true, completion: nil)
    }

}
