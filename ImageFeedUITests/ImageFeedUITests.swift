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
    
    func testFeed() throws {
        // 1. Подождать, пока открывается и загружается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10), "Первая ячейка не найдена в течение 10 секунд")
        
        // 2. Сделать жест «смахивания» вверх по экрану для его скролла
        cell.swipeUp()
        
        // 3. Поставить лайк в ячейке верхней картинки
        let likeButton = cell.buttons["noLike"]
        if !likeButton.waitForExistence(timeout: 10) {
            XCTFail("Кнопка 'noLike' не найдена")
            return
        }
        likeButton.tap()
        
        // Ожидание для стабилизации интерфейса
        sleep(1)
        
        // 4. Отменить лайк в ячейке верхней картинки
        likeButton.tap()
        
        // Ожидание для стабилизации интерфейса
        sleep(1)
        
        // 5. Нажать на верхнюю ячейку
        cell.tap()
        
        // 6. Подождать, пока картинка открывается на весь экран
        let scrollView = app.scrollViews.element(boundBy: 0)
        XCTAssertTrue(scrollView.waitForExistence(timeout: 10), "ScrollView не найден в течение 10 секунд")
        
        // 7. Увеличить картинку
        let image = scrollView.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 10), "Изображение не найдено в течение 10 секунд")
        image.pinch(withScale: 3, velocity: 1)   // Увеличиваем изображение
        
        // 8. Уменьшить картинку
        image.pinch(withScale: 0.5, velocity: -1)  // Уменьшаем изображение
        
        // 9. Вернуться на экран ленты
        let backButton = app.buttons["singleViewBackButton"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 10), "Кнопка возврата не найдена в течение 10 секунд")
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
