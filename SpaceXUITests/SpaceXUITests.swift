//
//  SpaceXUITests.swift
//  SpaceXUITests
//
//  Created by Aurelien Cobb on 10/05/2021.
//

import XCTest

class SpaceXUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws { }
    
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"FalconSat")/*[[".cells.containing(.staticText, identifier:\"-5532 days\")",".cells.containing(.staticText, identifier:\"3\/24\/06, 10:30 PM\")",".cells.containing(.staticText, identifier:\"FalconSat\")"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.staticTexts["Rocket:"].tap()
        app.children(matching: .window).element(boundBy: 0).tap()
        app.navigationBars["SpaceX"].buttons["volume lowest"].tap()
    }
}
