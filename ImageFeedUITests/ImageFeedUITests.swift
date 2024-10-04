//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Admin on 23.09.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let login = "baurasm@bk.ru"
    private let password = "1hd1gh243d"
    private let fullName = "Mihail Bauras"
    private let userName = "@fen1x1122"
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("UITests")
        app.launch()
    }
    
    func testAuth() throws {
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.textFields.element(boundBy: 0)
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 20))
        
        loginTextField.tap()
        loginTextField.typeText(login)
        
        webView.swipeUp()
        app.toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.secureTextFields.element(boundBy: 0)
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        webView.swipeUp()
        app.toolbars.buttons["Done"].tap()
        
        let loginButton = webView.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 10))
        loginButton.tap()
        
        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }

    
    func testFeed() throws {
        // Ожидание загрузки экрана ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        // Свайп вверх для загрузки дополнительных элементов
        cell.swipeUp()
        // Поставить лайк
        let likeButton = cell.buttons["noLike"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5), "Кнопка 'noLike' не найдена")
        likeButton.tap()
        
        // Ожидание для стабилизации интерфейса
        sleep(1)
        // Отменить лайк
        likeButton.tap()
        
        // Ожидание для стабилизации интерфейса
        sleep(1)
        
        // Нажать на верхнюю ячейку
        cell.tap()
        
        // Ожидание, пока картинка открывается на весь экран
        let scrollView = app.scrollViews.element(boundBy: 0)
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "ScrollView не найден")
        
        // Увеличить картинку
        let image = scrollView.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 10), "Изображение не найдено")
        image.pinch(withScale: 3, velocity: 1)   // Увеличиваем изображение
        // Уменьшить картинку
        image.pinch(withScale: 0.5, velocity: -1)  // Уменьшаем изображение
        // Вернуться на экран ленты
        let backButton = app.buttons["singleViewBackButton"] // Убедитесь, что этот идентификатор добавлен в код приложения
        XCTAssertTrue(backButton.waitForExistence(timeout: 5), "Кнопка возврата не найдена")
        backButton.tap()

    }
    
    func testProfile() throws {
        // Ожидание загрузки экрана ленты
        let table = app.tables.element(boundBy: 0)
        XCTAssertTrue(table.waitForExistence(timeout: 5), "Таблица не найдена")

        // Перейти на экран профиля
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        // Проверить, что на профиле отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts["\(fullName)"].waitForExistence(timeout: 5), "Полное имя не отображается")
        XCTAssertTrue(app.staticTexts["\(userName)"].waitForExistence(timeout: 5), "Имя пользователя не отображается")
        
        // Нажать кнопку логаута
        app.buttons["exit"].tap()
        
        // Ожидание, чтобы экран логаута был полностью открыт
        let alert = app.alerts["Пока, пока!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Экран логаута не появился")
        
        // Нажимаем "Да" для подтверждения выхода
        alert.scrollViews.otherElements.buttons["Да"].tap()
        
        // Ожидание, чтобы экран авторизации был открыт
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 10), "Экран авторизации не открыт")
    }
}
