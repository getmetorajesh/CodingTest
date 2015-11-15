//
//  WeatherApiClientTests.swift
//  WeatherApp
//
//  Created by Preethi on 16/11/2015.
//  Copyright © 2015 Techiepandas. All rights reserved.
//

import XCTest

class WeatherApiClientTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testWeatherApi() {
        let expectation = expectationWithDescription("...")

        let lat:Double = 12.00
        let long:Double = 12.00
        let api = WeatherApiClient()
        
        api.getWeatherForLatitude(lat, longitude: long,
            success: { (responseJSON) -> Void in
                XCTAssertNotNil(responseJSON, "Response should not be nil")
                expectation.fulfill()
            }) { (error) -> Void in
                XCTAssertNotNil(error, "Response should atleast return an error")
        }
        waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testWeatherApiPerformance() {
        self.measureBlock {
            self.testWeatherApi()
        }
    }

}
