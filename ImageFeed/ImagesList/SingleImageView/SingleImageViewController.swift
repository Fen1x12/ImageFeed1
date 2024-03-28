import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.5
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(scrollView.maximumZoomScale, max(scrollView.minimumZoomScale, min(hScale, vScale)))
        let targetWidth = imageSize.width * scale
        let targetHeight = imageSize.height * scale
        imageView.frame = CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight)
        scrollView.contentSize = imageView.frame.size
        view.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        scrollView.zoomScale = scale
        let verticalPadding = (scrollView.contentSize.height - scrollView.bounds.height) / 2
        let horizontalPadding =  (scrollView.contentSize.width - scrollView.bounds.width) / 2
        scrollView.contentOffset = CGPoint(x: horizontalPadding, y: verticalPadding)
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image!],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
}
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
