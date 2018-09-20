import XCTest

class TBAUITestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        app = XCUIApplication()
        app.launch()
    }

}
