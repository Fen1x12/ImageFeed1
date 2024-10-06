import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private(set) var photos: [Photo] = []
    private var currentTask: URLSessionTask?
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private let dateFormatter = ISO8601DateFormatter()
    
   public init() {}
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        // Если текущая задача не завершена, не начинаем новую загрузку
        guard currentTask == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let authToken = OAuth2TokenStorage.shared.token else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        
        guard let request = makeRequest(authToken: authToken, page: nextPage) else {
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResults):
                    self.lastLoadedPage = nextPage
                    let newPhotos = photoResults.map { Photo($0, date: self.dateFormatter) }
                    self.photos.append(contentsOf: newPhotos)
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                    // Сбрасываем currentTask при неудачной загрузке, чтобы попытаться заново
                    self.currentTask = nil
                }
            }
            
            // Обязательно сбрасываем currentTask при завершении задачи, чтобы разрешить последующие вызовы
            self.currentTask = nil
        }
        
        // Назначаем задачу и запускаем её
        self.currentTask = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        // Если текущая задача не завершена, не начинаем новую загрузку
        guard currentTask == nil else { return }
        
        guard let request = likeRequest(photoId: photoId, isLike: isLike) else {
            return
        }
        
        // Создаем новую задачу для изменения лайка
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoLiked, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        
                        let newPhotoResult = PhotoResult(
                            id: photo.id,
                            width: Int(photo.size.width),
                            height: Int(photo.size.height),
                            createdAt: photo.createdAt?.description,
                            description: photo.welcomeDescription,
                            urls: UrlsResult(
                                full: photo.largeImageURL,
                                regular: photo.regularImageURL,
                                small: photo.smallImageURL,
                                thumb: photo.thumbImageURL
                            ),
                            likedByUser: !photo.isLiked
                        )
                        
                        // Обновление информации о фото
                        self.photos[index] = Photo(newPhotoResult, date: self.dateFormatter)
                        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                    }
                    
                    completion(.success(()))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
                
                // Сбрасываем currentTask при завершении задачи
                self.currentTask = nil
            }
        }
        
        // Назначаем задачу и запускаем её
        self.currentTask = task
        task.resume()
    }
    
    func logout() {
        // Отмена текущей задачи, если она существует
        currentTask?.cancel()
        currentTask = nil
        
        // Сброс lastLoadedPage и очистка списка фотографий
        lastLoadedPage = nil
        photos = []
    }
}

private func makeRequest(authToken: String, page: Int) -> URLRequest? {
    guard var urlComponents = URLComponents(string: "https://api.unsplash.com/photos") else {
        assertionFailure("Error with URL")
        return nil
    }
    urlComponents.queryItems = [
        URLQueryItem(name: "page", value: "\(page)"),
        URLQueryItem(name: "per_page", value: "10")
    ]
    guard let url = urlComponents.url else {
        assertionFailure("Error with URL")
        return nil
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    return request
}

private func likeRequest(photoId: String, isLike: Bool) -> URLRequest? {
    let baseURL = "https://api.unsplash.com"
    let likeURL = "\(baseURL)/photos/\(photoId)/like"
    
    guard let url = URL(string: likeURL) else {
        assertionFailure("Error with URL")
        return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = isLike ? "POST" : "DELETE"
    
    guard let authToken = OAuth2TokenStorage.shared.token else {
        return nil
    }
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    
    return request
}
