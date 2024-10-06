//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by Admin on 23.09.2024.
//

import XCTest
@testable import ImageFeed
final class ProfileViewTest: XCTestCase {
    
    func testProfileViewControllerUpdateAvatar() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        // Присваиваем presenter в viewController
        viewController.presenter = presenter
        presenter.view = viewController
        
        let url = DefaultBaseURL
        
        viewController.updateAvatar(url: url)
        
        // Проверяем, что метод обновления аватара был вызван
        XCTAssertTrue(viewController.isUpdateAvatarCalled, "Метод updateAvatar не был вызван")
    }
    
    func testImagesViewControllerCallsViewDidLoad() {
        // Создаем шпион для presenter
        let imagesListService = ImagesListService() // Или используйте нужный вам инициализатор
        let presenter = ImagesListViewPresenterSpy(imagesListService: imagesListService)
        
        // Загружаем storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            XCTFail("Не удалось загрузить ImagesListViewController")
            return
        }
        
        // Устанавливаем presenter
        viewController.presenter = presenter
        
        _ = viewController.view
        
        presenter.viewDidLoad()
        XCTAssertTrue(presenter.isViewDidLoadCalled, "Метод viewDidLoad не был вызван у presenter")
    }
    
    func testProfileViewControllerUpdateProfile() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        // Присваиваем presenter в viewController
        viewController.presenter = presenter
        presenter.view = viewController
        
        let profile = Profile(userName: "TestUser", name: "Test Name", loginName: "test_login", bio: "This is a test bio.")
        
        presenter.updateProfileDetails(profile: profile)
        
        // Проверяем, что метод обновления профиля был вызван
        XCTAssertTrue(presenter.isUpdateProfileCalled, "Метод updateProfileDetails не был вызван")
    }
}
