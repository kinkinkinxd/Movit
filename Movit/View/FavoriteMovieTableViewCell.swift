
import UIKit
import Cosmos

class FavoriteMovieTableViewCell: UITableViewCell {
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var cellRating: UILabel!
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var releaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with movie: MovieModel) {
        favoriteButton.setTitle("", for: .normal)
        favoriteButton.setBackgroundImage(UIImage(named: "pink_heart.png"), for: .normal)
        cellTitle.text = movie.title
        if let url = URL(string: movie.getPosterPath()) {
            cellImage.kf.setImage(with: url)
            cellImage.layer.cornerRadius = 15
            cellRating.text = String(movie.getVoteAverage())
            starRating.rating = movie.getVoteAverage()
            releaseDate.text = movie.release_date
            
        }
    }
}

