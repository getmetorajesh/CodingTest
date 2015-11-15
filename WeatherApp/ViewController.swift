//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rj on 16/11/2015.
//  Copyright © 2015 Techiepandas. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, LocationMangerDelegate {
    var locationManager = LocationManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.authorize()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: LocationManagerDelegate methods
    func receivedWeatherUpdate(responseJSON: JSON) {
        
    }


}

