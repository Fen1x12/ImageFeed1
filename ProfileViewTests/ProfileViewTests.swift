//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by  Admin on 23.09.2024.
//
import XCTest
@testable import ImageFeed

final class ProfileViewTest: XCTestCase {
    
    func testProfileViewControllerUpdateAvatar() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let url = DefaultBaseURL
        
        viewController.updateAvatar(url: url)
        
        XCTAssertTrue(viewController.isUpdateAvatarCalled)
    }
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        presenter.viewDidLoad()
        
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
    
    func testProfileViewControllerUpdateProfile() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        let profile = Profile(userName: "", name: nil, loginName: "", bio: nil)
        
        presenter.updateProfileDetails(profile: profile)
        
        XCTAssertTrue(presenter.isUpdateProfileCalled)
    }
}
