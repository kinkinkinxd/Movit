import UIKit
import Cosmos
import Kingfisher
import RealmSwift


class MovieDetailViewController: UIViewController {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailView: UIView!
    let realm = try! Realm()
    
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var cellRating: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var favoriteMovies: RealmSwift.Results<MovieModel>?
    var movie: MovieModel?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteButton.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        favoriteMovies = realm.objects(MovieModel.self)
        favoriteButton.setTitle("", for: .normal)
        collectionView.backgroundColor = nil
        detailView.layer.cornerRadius = 10
        if let movieData = movie {
            let url = URL(string: movieData.getPosterPath())
            movieTitle.text = movieData.title
            descriptionLabel.text = movieData.overview
            posterImage.kf.setImage(with: url)
            dateLabel.text = movieData.release_date
            cellRating.text = String(movieData.getVoteAverage())
            starRating.rating = movieData.getVoteAverage()
        }
    }
    
    func didUpdateFavorites() {
        let notificationName = "DidUpdateFavoritesNotification"
        NotificationCenter.default.post(name: Notification.Name(notificationName), object: nil)
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add new movie", message: "", preferredStyle: .alert)
        do {
            try self.realm.write {
                if let movieData = movie {
                    if let favoriteMovie = favoriteMovies?.filter("title = %@", movieData.title).first {
                        let copiedMovie = MovieModel(title: movieData.title, overview: movieData.overview, poster_path: movieData.poster_path, release_date: movieData.release_date, vote_average: movieData.vote_average, genre_ids: movieData.genre_ids)
                            self.realm.delete(favoriteMovie.genreList)
                            self.realm.delete(favoriteMovie)
                            favoriteButton.setBackgroundImage(UIImage(named: "heart.png"), for: .normal)
                            alert.title = "This movie has been removed"
                            movie = copiedMovie
                            
                        }
                    else{
                        self.realm.add(movieData)
                        favoriteButton.setBackgroundImage(UIImage(named: "pink_heart.png"), for: .normal)
                    }
                }
            }
        } catch {
            print("Error saving new items, \(error)")
        }
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true, completion: nil)
            self.didUpdateFavorites()
        }
    }
}

//MARK: - MovieDetailView Datasource & Delegate

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movie?.genre_ids.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Genre", for: indexPath) as! GenreCollectionViewCell
        cell.setup(movie?.genre_ids[indexPath.row] ?? 0)
        if let movieData = movie {
            let favoriteMovie = favoriteMovies?.filter("title = %@", movieData.title).first
            if movieData.title == favoriteMovie?.title {
                favoriteButton.setBackgroundImage(UIImage(named:"pink_heart.png"), for: .normal)
            }
        }
       
        return cell
    }
}

