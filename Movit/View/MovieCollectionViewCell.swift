import UIKit
import Kingfisher
import Cosmos

class MovieCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellRating: UILabel!
    @IBOutlet weak var starRating: CosmosView!
    
    func setup(_ movie: MovieModel) {
        let url = URL(string: movie.getPosterPath())
        cellImage.kf.setImage(with: url)
        cellTitle.text = movie.title
        cellRating.text = String(movie.getVoteAverage())
        starRating.rating = movie.getVoteAverage()

    }
    
    
}

