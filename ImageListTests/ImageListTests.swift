//
//  ImageListTests.swift
//  ImageListTests
//
//  Created by  Admin on 23.09.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    
    func testImagesViewControllerCallsViewDidLoad() {
        let imageListService = ImagesListService()
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imagesListService: imageListService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testLike () {
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        
        view.changeLike()
        
        XCTAssertTrue(presenter.didSetLikeCallSuccess)
    }
    
    func testLoadPhotoToTable() {
        let tableView = UITableView()
        let tableCell = UITableViewCell()
        let indexPath: IndexPath = IndexPath(row: 2, section: 2)
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        
        view.tableView(tableView, willDisplay: tableCell, forRowAt: indexPath)
        
        XCTAssertTrue(presenter.didFetchPhotosCalled)
    }
}
