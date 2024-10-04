//
//  ImagesListViewPresenterSpy .swift
//  ImageFeed
//
//  Created by  Admin on 04.10.2024.
//

import Foundation
protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
}

// Шпион для тестов
final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var imagesListService: ImagesListServiceProtocol? // Убедитесь, что у вас есть этот протокол
    
    // Переменные для отслеживания вызовов
    var isViewDidLoadCalled = false
    var isCheckCompletedListCalled = false
    var isChangeLikeCalled = false
    var changeLikePhotoId: String?
    var changeLikeIsLike: Bool?
    var changeLikeCompletion: ((Result<Void, Error>) -> Void)?

    // Метод viewDidLoad из протокола
    func viewDidLoad() {
        isViewDidLoadCalled = true
    }
    
    // Метод checkCompletedList из протокола
    func checkCompletedList(_ indexPath: IndexPath) {
        isCheckCompletedListCalled = true
    }
    
    // Метод changeLike из протокола
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        isChangeLikeCalled = true
        changeLikePhotoId = photoId
        changeLikeIsLike = isLike
        changeLikeCompletion = completion
        
        // Имитация успешного изменения состояния лайка
        completion(.success(()))
    }
}
