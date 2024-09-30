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
        // Получаем таблицу с элементами
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        // Убедимся, что первая ячейка существует
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        // Свайп вверх для загрузки дополнительных элементов
        cell.swipeUp()

        // Находим кнопку "noLike" в первой ячейке
        let likeButton = cell.buttons["noLike"]
        
        // Убедимся, что кнопка лайка существует
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5), "Кнопка 'noLike' не найдена")

        // Нажимаем кнопку "Like"
        if likeButton.isHittable {
            likeButton.tap()
        } else {
            let coordinate = likeButton.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            coordinate.tap()
        }
        
        // Ожидание для стабилизации интерфейса
        sleep(5)
        
        // Нажимаем кнопку повторно для отмены лайка
        if likeButton.isHittable {
            likeButton.tap()
        } else {
            let coordinate = likeButton.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            coordinate.tap()
        }
        
        // Ожидание для стабилизации интерфейса
        sleep(5)

        // Проверяем, выполняется ли тестирование
        let isTesting = ProcessInfo.processInfo.arguments.contains("UITests")

        // Если в режиме тестирования, отключаем пагинацию
        if !isTesting {
            // Здесь должен быть вызов метода для пагинации, например:
            // fetchPhotosNextPage()
            // Но в режиме тестов он не выполняется
        }
        
        // Открываем изображение в первой ячейке
        cell.tap()

        // Проверяем наличие ScrollView для изображения
        let scrollView = app.scrollViews.element(boundBy: 0)
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "ScrollView не найден")

        // Находим изображение в ScrollView
        let image = scrollView.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 10), "Изображение не найдено")

        // Выполняем зумирование изображения
        image.pinch(withScale: 3, velocity: 1)   // Увеличиваем изображение
        image.pinch(withScale: 0.5, velocity: -1)  // Уменьшаем изображение
        
        // Возвращаемся назад, добавив идентификатор для кнопки "Back"
        let navBackButtonWhiteButton = app.buttons["singleViewBackButton"] // Убедитесь, что этот идентификатор добавлен в код приложения
        XCTAssertTrue(navBackButtonWhiteButton.waitForExistence(timeout: 5), "Кнопка возврата не найдена")
        
        // Нажимаем на кнопку возврата
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
