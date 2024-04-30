import UIKit


final class SingleImageViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBAction private func didTapShareButton(_ sender: Any) {
        let sharingButton = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
        present(sharingButton, animated: true)
    }
    @IBOutlet private var scrollView: UIScrollView!
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - «Научим» SingleViewController показывать разные картинки, не инициируя загрузку view
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image 
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
