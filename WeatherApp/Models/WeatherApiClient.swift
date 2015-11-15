//
//  WeatherApiClient.swift
//  WeatherApp
//
//  Created by Preethi on 16/11/2015.
//  Copyright © 2015 Techiepandas. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherApiClient: NSObject {
    // MARK: Shared singleton
    class var sharedInstance: WeatherApiClient {
        struct Static {
            static let instance: WeatherApiClient = WeatherApiClient()
        }
        return Static.instance
    }
    
    // MARK: Public methods
    func getWeatherForLatitude(latitude: Double,
        longitude: Double,
        success:(responseJSON:JSON)-> Void,
        failure:(error:NSError) -> Void) {
    
        let lat = String(latitude)
        let long = String(longitude)
        Alamofire.request(.GET, Config.apiUrl+"/"+lat+","+long, parameters: ["": ""])
            .validate(statusCode: 200...299)
            .responseJSON { res in
            switch res.result {
            case .Success:
                let json = JSON(res.result.value!)
                print(json);
                success(responseJSON: json)
            case .Failure(let error):
                failure(error: error)
                }
            }
    }
}