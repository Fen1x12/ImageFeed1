//
//  ListViewPresenter.swift
//  ImageListTests
//
//  Created by  Admin on 23.09.2024.
//

import UIKit
@testable import ImageFeed


final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var didFetchPhotosCalled: Bool = false
    var didSetLikeCallSuccess: Bool = false
    var imagesListService: ImageFeed.ImagesListService
    
    init(imagesListService: ImagesListService){
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        didFetchPhotosCalled = true
    }
    
    func checkCompletedList(_ indexPath: IndexPath) {
        fetchPhotosNextPage()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        didSetLikeCallSuccess = true
    }
    
    func makeAlert(with error: Error) -> UIAlertController {
        UIAlertController()
    }
}
