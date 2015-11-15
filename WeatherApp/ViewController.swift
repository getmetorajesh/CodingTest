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
    // MARK: Properties
    var locationManager = LocationManager.sharedInstance
    @IBOutlet weak var txtResponse: UITextView!
    @IBOutlet weak var lblTemperature: UILabel!
    
    // MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.authorize()
        locationManager.delegate = self
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func updateUIElements(temp: String, response: String) {
        txtResponse.text = response
        lblTemperature.text = temp
    }

    // MARK: LocationManagerDelegate methods
    func receivedWeatherUpdate(responseJSON: JSON) {
        let curTemp = responseJSON["currently"]
        let res = "\(curTemp["temperature"].stringValue) F, \(curTemp["summary"].stringValue)"
        updateUIElements(res, response: responseJSON.description)
    }
    func errorResponse(error: NSError) {
        updateUIElements("Failed to get proper response", response: error.description)
    }
    
    func alertWithTitle(title: String, message: String) {
        updateUIElements(title, response: message)
        UIAlertView(title: title,
            message: message,
            delegate: nil,
            cancelButtonTitle: "OK").show()
    }
}

