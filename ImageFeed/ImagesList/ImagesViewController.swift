import UIKit
import Kingfisher


final class ImagesListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateTableViewAnimated()
                }
        imageListService.fetchPhotosNextPage()
        
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.string(from: Date())
        return formatter
    }()
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListService = ImagesListService.shared
    private var photosList: [Photo] = []
    private var imageListServiceObserver: NSObjectProtocol?
    
    
    @IBOutlet private var tableView: UITableView!
    
    // Жестко установим цвет StatusBar в светлый
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            if let indexPath = sender as? IndexPath {
                let urlImageList = URL(string: photosList[indexPath.row].fullImageURL)
                viewController?.fullImageURL = urlImageList
                
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    }
}


extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let photo = photosList[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success:
                self.photosList = self.imageListService.photos
                cell.setIsLiked(isLiked: !photo.isLiked)
            case .failure(let error):
                print("imageListCellDidTapLike Error: \(error)")
                self.showErrorAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Ок",
            style: .default))
        self.present(alert, animated: true)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
            let photos = imageListService.photos
            if indexPath.row + 1 == photos.count {
                imageListService.fetchPhotosNextPage()
            }
        }
    
    func updateTableViewAnimated() {
        let oldCount = photosList.count
        let newCount = imageListService.photos.count
        photosList = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let stubImage = UIImage(named: "scribble.variable") else { return }
        let imageUrl = photosList[indexPath.row].thumbImageURL
        guard let url = URL(string: imageUrl) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: stubImage) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.setIsLiked(isLiked: photosList[indexPath.row].isLiked)
        let photo = photosList[indexPath.row]
        if let photoCreatedAt = photo.createdAt {
            cell.dataLabel.text = dateFormatter.string(from: photoCreatedAt)
        } else {
            cell.dataLabel.text = ""
        }
    }
}
