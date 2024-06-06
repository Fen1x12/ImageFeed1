import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dataLabel: UILabel!
    
    @IBAction func likeButtonClicked2(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
        
        func setIsLiked(isLiked: Bool) {
            let likeImage = isLiked ? UIImage(named: "FavoritesYesActive") : UIImage(named: "FavoritesNoActive")
            likeButton.setImage(likeImage, for: .normal)
        }
        weak var delegate: ImagesListCellDelegate?
        
        override func prepareForReuse() {
            super.prepareForReuse()
            cellImage.kf.cancelDownloadTask()
        }
    }

    protocol ImagesListCellDelegate: AnyObject {
        func imageListCellDidTapLike(_ cell: ImagesListCell)
    }
