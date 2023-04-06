//
//  SmoothWalker_Watch_App_Watch_AppUITestsLaunchTests.swift
//  SmoothWalker Watch App Watch AppUITests
//
//  Created by Mateo Rodriguez on 4/4/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import XCTest

final class SmoothWalker_Watch_App_Watch_AppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
