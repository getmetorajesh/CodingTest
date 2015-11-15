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
    func errorResponse(error: NSError)
    func alertWithTitle(title: String, message: String)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: Properties
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var apiClient = WeatherApiClient.sharedInstance
    var delegate = LocationMangerDelegate?()

    //MARK: Singleton
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
                self.delegate?.alertWithTitle("Not Determined",
                    message: "Please enable location services and try again!")
            case .NotDetermined:
                // request access
                locationManager.requestWhenInUseAuthorization()
            case .Restricted:
                self.delegate?.alertWithTitle("Restricted",
                    message: "Please enable location services and try again!")
            }
        } else {
            self.delegate?.alertWithTitle("Not Enabled",
                message: "Location services are not enabled.")
        }
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
                self.delegate?.alertWithTitle("Not Enabled",
                    message: "Location services are not enabled on this device")
            }
        } else {
            self.delegate?.alertWithTitle("Not Enabled",
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
        self.stopUpdatingLocation()
        // Stop the location manager as soon as we get the location
        apiClient.getWeatherForLatitude((currentLocation?.coordinate.latitude)!,
            longitude: (currentLocation?.coordinate.longitude)!,
            success: { (responseJSON) -> Void in
                self.delegate?.receivedWeatherUpdate(responseJSON)
            }) { (error) -> Void in
                self.delegate?.errorResponse(error)
        }
    }
}
