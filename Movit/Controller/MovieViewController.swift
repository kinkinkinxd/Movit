import UIKit


class MovieViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieManager = MovieManager()
    var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        movieManager.fetchNowPlayingMovie()
        dispatchGroup.leave()
        dispatchGroup.enter()
        movieManager.fetchPopularMovie()
        dispatchGroup.leave()
        dispatchGroup.enter()
        movieManager.fetchUpcomingMovie()
        dispatchGroup.leave()
        sections.removeAll()
        collectionView.collectionViewLayout = createLayout()
    }
    
    
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section {
            case .nowPlaying:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.5)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 0, leading: 10, bottom: 30, trailing: 10)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            case .popular:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(0.3)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 0, leading: 10, bottom: 30, trailing: 10)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            case .upcoming:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(0.3)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            }
        }
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}


//MARK: - MovieViewController Datasource & Delegate
extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .nowPlaying(let movies):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
            cell.setup(movies[indexPath.row])
            return cell
        case .popular(let movies):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
            cell.setup(movies[indexPath.row])
            return cell
        case .upcoming(let movies):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
            cell.setup(movies[indexPath.row])
            return cell
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewHeaderReusableView", for: indexPath) as! CollectionViewHeaderReusableView
            header.setup(sections[indexPath.section].title)
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
//MARK: - Perform segue
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieDetailViewController = segue.destination as? MovieDetailViewController,
                 let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first,
                 sections.indices.contains(selectedIndexPath.section) else {
               return
           }
           
           let section = sections[selectedIndexPath.section]
           let movies: [MovieModel]
           
           switch section {
           case .nowPlaying(let nowPlayingMovies):
               movies = nowPlayingMovies
           case .popular(let popularMovies):
               movies = popularMovies
           case .upcoming(let upcomingMovies):
               movies = upcomingMovies
           }
           
           guard movies.indices.contains(selectedIndexPath.row) else {
               return
           }
           
           let movieModel = movies[selectedIndexPath.row]
           movieDetailViewController.movie = movieModel
    }
}


//MARK: - MovieManager Delegate
extension MovieViewController: MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movies: [MovieModel], section: String) {
        DispatchQueue.main.async {
            switch section {
            case "nowPlaying":
                let nowPlaying: Section = {
                    .nowPlaying(movies)
                }()
                self.sections.append(nowPlaying)
            case "popular":
                let popular: Section = {
                    .popular(movies)
                }()
                self.sections.append(popular)
            case "upcoming":
                let upcoming: Section = {
                    .upcoming(movies)
                }()
                self.sections.append(upcoming)
            default:
                print("No data")
            }
            self.collectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
