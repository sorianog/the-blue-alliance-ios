import XCTest

class SettingsViewController_UITestCase: TBAUITestCase {

    override func setUp() {
        super.setUp()

        XCUIApplication().tabBars.buttons["Settings"].tap()
    }

    func test_openWebiste() {
        let tba = XCUIApplication(bundleIdentifier: "com.the-blue-alliance.the-blue-alliance")
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")

        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["The Blue Alliance Website"]/*[[".cells.staticTexts[\"The Blue Alliance Website\"]",".staticTexts[\"The Blue Alliance Website\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        _ = safari.wait(for: .runningForeground, timeout: 10)
        tba.activate()
        _ = tba.wait(for: .runningForeground, timeout: 10)
    }

    func test_openGitHub() {
        let tba = XCUIApplication(bundleIdentifier: "com.the-blue-alliance.the-blue-alliance")
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")

        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["The Blue Alliance for iOS is open source"]/*[[".cells.staticTexts[\"The Blue Alliance for iOS is open source\"]",".staticTexts[\"The Blue Alliance for iOS is open source\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        _ = safari.wait(for: .runningForeground, timeout: 10)
        tba.activate()
        _ = tba.wait(for: .runningForeground, timeout: 10)
    }

    func test_deleteNetworkCache() {
        let tablesQuery = XCUIApplication().tables
        let deleteNetworkCacheStaticText = tablesQuery/*@START_MENU_TOKEN@*/.cells.staticTexts["Delete network cache"]/*[[".cells.staticTexts[\"Delete network cache\"]",".staticTexts[\"Delete network cache\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        deleteNetworkCacheStaticText.tap()

        let deleteNetworkCacheAlert = XCUIApplication().alerts["Delete Network Cache"]
        deleteNetworkCacheAlert.buttons["Cancel"].tap()
        XCTAssertFalse(deleteNetworkCacheAlert.exists)

        deleteNetworkCacheStaticText.tap()
        deleteNetworkCacheAlert.buttons["Delete"].tap()
        XCTAssertFalse(deleteNetworkCacheAlert.exists)
    }

    func test_deleteAppData() {
        let tablesQuery = XCUIApplication().tables
        let deleteAppDataStaticText = tablesQuery/*@START_MENU_TOKEN@*/.cells.staticTexts["Delete app data"]/*[[".cells.staticTexts[\"Delete app data\"]",".staticTexts[\"Delete app data\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        deleteAppDataStaticText.tap()

        let deleteAppDataAlert = XCUIApplication().alerts["Delete App Data"]
        deleteAppDataAlert.buttons["Cancel"].tap()
        XCTAssertFalse(deleteAppDataAlert.exists)

        deleteAppDataStaticText.tap()
        deleteAppDataAlert.buttons["Delete"].tap()
        XCTAssertFalse(deleteAppDataAlert.exists)
    }

}
