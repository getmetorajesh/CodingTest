//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Preethi on 16/11/2015.
//  Copyright © 2015 Techiepandas. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

protocol LocationMangerDelegate{
    func receivedWeatherUpdate(responseJSON: JSON)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var apiClient = WeatherApiClient.sharedInstance
    var delegate = LocationMangerDelegate?()

    
    class var sharedInstance: LocationManager {
        struct Static {
            static let instance: LocationManager = LocationManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func authorize() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .Authorized:
                print("LocationManager: Authorized")
            case .AuthorizedWhenInUse:
                print("LocationManager: Authorized")
            case .Denied:
                alertWithTitle("Not Determined",
                    message: "Please enable location services and try again!")
            case .NotDetermined:
                // request access
                locationManager.requestWhenInUseAuthorization()
            case .Restricted:
                alertWithTitle("Restricted",
                    message: "Please enable location services and try again!")
            }
        } else {
            alertWithTitle("Not Enabled",
                message: "Location services are not enabled.")
        }
    }
    
    func alertWithTitle(title: String, message: String) {
        UIAlertView(title: title,
            message: message,
            delegate: nil,
            cancelButtonTitle: "OK").show()
    }
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .Authorized:
                // Yes, always
                locationManager.startUpdatingLocation()
            case .AuthorizedWhenInUse:
                // Yes, only when our app is in use
                locationManager.startUpdatingLocation()
            default:
                print("Location Manager: Not started")
            }
        } else {
            alertWithTitle("Not Enabled",
                message: "Location services are not enabled on this device")
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        apiClient.getWeatherForLatitude((currentLocation?.coordinate.latitude)!,
            longitude: (currentLocation?.coordinate.longitude)!,
            success: { (responseJSON) -> Void in
                self.delegate?.receivedWeatherUpdate(responseJSON)
            }) { (error) -> Void in
                //TODO://
        }
    }
}
