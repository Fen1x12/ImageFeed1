//
//  ImagesListViewPresenterSpy .swift
//  ImageFeed
//
//  Created by  Admin on 04.10.2024.
//

import Foundation

// Объявляем протокол ImagesListServiceProtocol, если он еще не объявлен
protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
}

// Шпион для тестов
final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: (any ImagesListViewControllerProtocol)?
    
    // Переменные для отслеживания вызовов
    var isViewDidLoadCalled = false
    var isChangeLikeCalled = false
    var isCheckCompletedListCalled = false
    var changeLikePhotoId: String?
    var changeLikeIsLike: Bool?
    var changeLikeCompletion: ((Result<Void, Error>) -> Void)?
    
    // Используемый сервис для получения списка изображений
    var imagesListService: ImagesListService
    
    // Инициализатор для установки imagesListService
    init(imagesListService: ImagesListService) {
        self.imagesListService = imagesListService
    }

    // Метод viewDidLoad из протокола
    func viewDidLoad() {
        isViewDidLoadCalled = true
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
    
    // Метод checkCompletedList из протокола
    func checkCompletedList(_ indexPath: IndexPath) {
        isCheckCompletedListCalled = true
    }
    
    // Метод для загрузки следующей страницы изображений
    func fetchPhotosNextPage() {
        // Здесь можно добавить логику для проверки, была ли вызвана эта функция
    }
}
