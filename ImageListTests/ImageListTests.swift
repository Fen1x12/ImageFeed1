//
//  ImageListTests.swift
//  ImageListTests
//
//  Created by  Admin on 23.09.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    
    func testImagesViewControllerCallsViewDidLoad() throws {

        let imagesListService = ImagesListService()
        let presenter = ImagesListViewPresenterSpy(imagesListService: imagesListService)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            XCTFail("Не удалось загрузить ImagesListViewController")
            return
        }
        
        viewController.presenter = presenter
        
        _ = viewController.view
        
        XCTAssertNotNil(viewController.presenter, "Presenter не был установлен")
        
        XCTAssertTrue(presenter.isViewDidLoadCalled, "Метод viewDidLoad не был вызван у presenter")
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
