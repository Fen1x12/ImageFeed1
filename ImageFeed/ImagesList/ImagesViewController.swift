import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    var photos: [Photo] { get set }
    func updateTableViewAnimated()
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    // Presenter теперь можно задать извне, что позволяет использовать mock/spy для тестов
    var presenter: ImagesListViewPresenterProtocol?
    
    var photos: [Photo] = []
    private let showSingleImageSegueIdentifire = "ShowSingleImage"
    private let alertManager = AlertManager.shared
    
    @IBOutlet private var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Presenter должен быть инициализирован извне
        presenter?.view = self
        presenter?.viewDidLoad() // Вызов метода viewDidLoad у presenter

        setupTableView() // Настройка tableView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showSingleImageSegueIdentifire,
              let viewController = segue.destination as? SingleImageViewController,
              let indexPath = sender as? IndexPath else {
            super.prepare(for: segue, sender: sender)
            return
        }
        let photo = photos[indexPath.row].largeImageURL
        let largeImageURL = URL(string: photo)
        viewController.image = largeImageURL
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        guard let newPhotos = presenter?.imagesListService.photos else { return }
        photos = newPhotos
        
        if oldCount != photos.count {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<photos.count).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .fade)
            } completion: { _ in }
        }
    }
    
    // Проверка, запущено ли приложение в режиме тестирования
    func isRunningUITest() -> Bool {
        return ProcessInfo.processInfo.arguments.contains("UITests")
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        
        let photo = photos[indexPath.row]
        imageListCell.setupCell(from: photo)
        return imageListCell
    }
}
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifire, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Проверка, выполняется ли приложение в режиме тестирования
        if isRunningUITest() { return } // Не выполняем пагинацию в режиме тестирования
        
        if indexPath.row + 1 == photos.count {
            presenter?.checkCompletedList(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        presenter?.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                guard let newPhotos = self.presenter?.imagesListService.photos else { return }
                self.photos = newPhotos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
                
            case .failure(let error):
                self.showLikeErrorAlert(with: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func showLikeErrorAlert(with error: Error) {
        let alert = alertManager.likeAlert(with: error) // передаем объект ошибки
        present(alert, animated: true, completion: nil)
    }
}
