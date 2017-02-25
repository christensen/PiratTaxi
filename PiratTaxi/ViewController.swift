//
//  ViewController.swift
//  PiratTaxi
//
//  Created by Jens Christensen on 2017-02-25.
//  Copyright © 2017 Christensen Software. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var startPriceLabel: UILabel!
    @IBOutlet weak var hourPriceLabel: UILabel!
    @IBOutlet weak var kmPriceLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var startChargeButton: UIButton!

    var startPrice: Int!
    var hourPrice: Int!
    var kmPrice: Int!
    var currentPrice: Double!
    
    var wasStarted: Bool!
    var wasPaused: Bool!
    
    var startPriceWhenStarted: Int!
    var hourPriceWhenStarted: Int!
    var kmPriceWhenStarted: Int!
    
    var accumulatedTimePrice: Double!
    var accumulatedKilometerPrice: Double!
    
    var timer: Timer!
    
    var locationManager: CLLocationManager!
    
    var oldLocation: CLLocation!
    var distanceTravelled: CLLocationDistance!

    @IBAction func startCharge(_ sender: Any) {
        // Set starting price...
        // Change button text to pause..
        if startChargeButton.currentTitle == "Start" {
            wasStarted = true;
            startChargeButton.setTitle("Pause", for:.normal)
            if wasPaused == nil || !wasPaused {
                currentPriceLabel.text = String(Int(currentPrice) + startPrice) + ",-"
                wasPaused = false;
            }
            // Start timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePrice), userInfo: nil, repeats: true)
        } else {
            wasPaused = true;
            startChargeButton.setTitle("Start", for:.normal)
            // Pause timer to stop from updating price
            timer.invalidate()
            timer = nil
        }
    }
    
    @IBAction func stopCharge(_ sender: Any) {
        startChargeButton.setTitle("Start", for:.normal)
        // Stop timer
        if timer != nil && timer.isValid {
            timer.invalidate()
        }
        // Reset variables
        wasStarted = false;
        wasPaused = false;
        resetVariables()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        // Do any additional setup after loading the view, typically from a nib.
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore  {
            print("First launch!")
            defaults.setValue(true, forKey: "launchedBefore")
            defaults.setValue(32, forKey: "startPrice")
            defaults.setValue(200, forKey: "hourPrice")
            defaults.setValue(5, forKey: "distancePrice")
        }
        locationManager = CLLocationManager();
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation();
        startPrice = defaults.integer(forKey: "startPrice")
        hourPrice = defaults.integer(forKey: "hourPrice")
        kmPrice = defaults.integer(forKey: "distancePrice")
        resetVariables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        startPrice = defaults.integer(forKey: "startPrice")
        hourPrice = defaults.integer(forKey: "hourPrice")
        kmPrice = defaults.integer(forKey: "distancePrice")
        startPriceLabel.text = String(startPrice) + ",-"
        hourPriceLabel.text = String(hourPrice) + ",-"
        kmPriceLabel.text = String(kmPrice) + ",-"
        if wasStarted != nil && !wasStarted {
            resetVariables()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let newLocation:CLLocation = locations[locations.count-1]
        
        if oldLocation != nil {
            distanceTravelled = newLocation.distance(from: oldLocation)
        }
        
        oldLocation = newLocation
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error)
        print("Can't get your location!")
    }
    
    func updatePrice() {
        let pricePerSecond = Double(hourPriceWhenStarted) / 3600
        accumulatedTimePrice = pricePerSecond + accumulatedTimePrice
        let pricePerTravelledDistance = (Double(kmPriceWhenStarted) / 1000) * distanceTravelled
        accumulatedKilometerPrice = pricePerTravelledDistance + accumulatedKilometerPrice
        currentPrice = Double(accumulatedTimePrice + accumulatedKilometerPrice)
        let textPrice = Int(currentPrice) + startPriceWhenStarted
        
        currentPriceLabel.text = String(textPrice) + ",-"
    }
    
    func resetVariables() {
        accumulatedTimePrice = 0.0
        accumulatedKilometerPrice = 0.0
        currentPrice = 0.0
        distanceTravelled = 0.0
        startPriceWhenStarted = startPrice
        hourPriceWhenStarted = hourPrice
        kmPriceWhenStarted = kmPrice
    }
    
    /*func stripStringAndConvertToInt(priceString: String) -> Int {
        let endIndexPS = priceString.index(priceString.endIndex, offsetBy: -2)
        let truncPriceStr = priceString.substring(to: endIndexPS)
        return Int(truncPriceStr)!
    }*/
}

