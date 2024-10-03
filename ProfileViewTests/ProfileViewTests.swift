//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by  Admin on 23.09.2024.
//

import XCTest
@testable import ImageFeed

// Spy для ProfileViewController
final class ProfileViewControllerTestSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    // Флаг для отслеживания вызова updateAvatar
    var isUpdateAvatarCalled = false
    
    func updateAvatar(url: URL) {
        isUpdateAvatarCalled = true
    }
    
    func updateProfileDetails(profile: Profile) {}
}

// Spy для ProfileViewPresenter
final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    var isUpdateProfileCalled = false
    
    func viewDidLoad() {}
    
    func updateProfileDetails(profile: Profile) {
        isUpdateProfileCalled = true
    }
    func updateAvatar(url: URL) {}
}

final class ProfileViewTest: XCTestCase {
    
    // Тест на обновление аватара
    func testProfileViewControllerUpdateAvatar() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let url = URL(string: "https://example.com/avatar.jpg")!  // Используем фиктивный URL
        
        viewController.updateAvatar(url: url)
        
        // Проверяем, что метод обновления аватара был вызван
        XCTAssertTrue(viewController.isUpdateAvatarCalled, "Метод updateAvatar не был вызван")
    }
    
    // Тест, который проверяет, был ли инициализирован presenter
    func testImagesViewControllerCallsViewDidLoad() throws {
        // Загружаем storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            XCTFail("Не удалось загрузить ImagesListViewController")
            return
        }
        
        // Принудительно вызываем загрузку view
        _ = viewController.view  // Загрузка view, чтобы вызвать viewDidLoad()
        
        // Проверяем, что presenter инициализирован
        XCTAssertNotNil(viewController.presenter, "Presenter не был установлен")
    }
    
    // Тест на обновление профиля
    func testProfileViewControllerUpdateProfile() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // Модель профиля
        let profile = Profile(userName: "TestUser", name: "Test Name", loginName: "test_login", bio: "This is a test bio.")
        
        presenter.updateProfileDetails(profile: profile)
        
        // Проверяем, что метод обновления профиля был вызван
        XCTAssertTrue(presenter.isUpdateProfileCalled, "Метод updateProfileDetails не был вызван")
    }
}
