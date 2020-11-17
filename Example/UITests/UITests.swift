import XCTest

class UITests: XCTestCase {
    let paymentSessionService = PaymentSessionService()!

    var sessionURL: URL!

    override func setUpWithError() throws {
        continueAfterFailure = false

        // Create payment session
        let sessionExpectation = expectation(description: "Create payment session")
        let transaction = Transaction.loadFromTemplate()

        var createSessionResult: Result<URL, Error>?

        paymentSessionService.create(using: transaction, completion: { (result) in
            createSessionResult = result
            sessionExpectation.fulfill()
        })

        wait(for: [sessionExpectation], timeout: 5)

        switch createSessionResult {
        case .success(let url): self.sessionURL = url
        case .failure(let error): throw error
        case .none: throw "Create session result wasn't set"
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVISAProceed() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Initial screen
        let tablesQuery = app.tables
        if tablesQuery.buttons["Clear text"].exists {
            tablesQuery.buttons["Clear text"].tap()
        }
        tablesQuery.textFields.firstMatch.typeText(sessionURL.absoluteString)
        tablesQuery.staticTexts["Send request"].tap()

        // List
        app.tables.staticTexts["Cards"].tap()

        // Input
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.textFields["Card Number"].tap()
        collectionViewsQuery.textFields["Card Number"].typeText("4111111111111111")

        collectionViewsQuery.textFields["MM / YY"].tap()
        collectionViewsQuery.textFields["MM / YY"].typeText("1030")

        collectionViewsQuery.textFields["Security Code"].tap()
        collectionViewsQuery.textFields["Security Code"].typeText("111")

        collectionViewsQuery.textFields["Name on card"].tap()
        collectionViewsQuery.textFields["Name on card"].typeText("Test Test")

        collectionViewsQuery.buttons["Pay"].tap()

        // Check result
        let interactionResult = app.alerts.firstMatch.staticTexts.element(boundBy: 1).label
        let expectedResult = "ResultInfo: Approved Interaction code: PROCEED Interaction reason: OK Error: n/a"
        XCTAssertEqual(expectedResult, interactionResult)
    }
    
    func testClearButton() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Initial screen
        let tablesQuery = app.tables
        if tablesQuery.buttons["Clear text"].exists {
            tablesQuery.buttons["Clear text"].tap()
        }
        tablesQuery.textFields.firstMatch.typeText(sessionURL.absoluteString)
        tablesQuery.staticTexts["Send request"].tap()

        // List
        app.tables.staticTexts["Cards"].tap()

        // Input
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.textFields["Card Number"].tap()
        
        let clearButton = app.collectionViews.buttons["iconClear"]
        let cardNumberTextField = collectionViewsQuery.textFields["Card Number"]

        XCTAssertFalse(clearButton.exists, "Clear button should be hidden")

        cardNumberTextField.typeText("4111")
        XCTAssertTrue(clearButton.exists, "Clear button should be visible")
        
        clearButton.tap()
        XCTAssertEqual(cardNumberTextField.value as! String, "", "Text wasn't cleared")
    }
}
