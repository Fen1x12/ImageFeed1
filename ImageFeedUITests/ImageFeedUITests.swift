//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by  Admin on 23.09.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let login = "baurasm@bk.ru"
    private let password = "rozqex-josvow-1wafTa"
    private let fullName = "Mihail Bauras"
    private let userName = "@fen1x1122"
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
        app.buttons["Authenticate"].tap()

        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))

        let loginTextField = webView.textFields.element(boundBy: 0)
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))

        loginTextField.tap()
        loginTextField.typeText(login)

        // Скрытие клавиатуры свайпом
        webView.swipeUp()

        app.toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.secureTextFields.element(boundBy: 0)
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))

        passwordTextField.tap()
        passwordTextField.typeText(password)

        // Скрытие клавиатуры свайпом
        webView.swipeUp()

        app.toolbars.buttons["Done"].tap()

        let loginButton = webView.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 10))
        loginButton.tap()

        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.swipeUp()

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
        let likeButton = cellToLike.buttons["noLike"]
        likeButton.tap()
        sleep(5)
        likeButton.tap()
        sleep(5)
        cellToLike.tap()
        sleep(5)

        let scrollView = app.scrollViews.element(boundBy: 0)
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "ScrollView не найден")
        let image = scrollView.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 10), "Изображение не найдено")

        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["singleViewBackButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["\(fullName)"].exists)
        XCTAssertTrue(app.staticTexts["\(userName)"].exists)
        
        app.buttons["exit"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
    }
}
