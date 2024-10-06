//
//  ViewController.swift
//  ProfileViewTests
//
//  Created by  Admin on 23.09.2024.
//

import Foundation
import ImageFeed

// Spy для ProfileViewController
class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?

    // Свойства для проверки вызова методов
    var isUpdateAvatarCalled = false
    var updatedAvatarURL: URL?

    var isNameLabelCalled = false
    var updatedName: String?

    var isUserNameLabelCalled = false
    var updatedUserName: String?

    var isDescriptionLabelCalled = false
    var updatedDescription: String?

    // Реализация методов протокола ProfileViewControllerProtocol

    func updateAvatar(url: URL) {
        isUpdateAvatarCalled = true
        updatedAvatarURL = url
    }
    
    func nameLabel(_ name: String) {
        isNameLabelCalled = true
        updatedName = name
    }

    func userNameLabel(_ userName: String) {
        isUserNameLabelCalled = true
        updatedUserName = userName
    }

    func descriptionLabel(_ description: String) {
        isDescriptionLabelCalled = true
        updatedDescription = description
    }
}
