import Foundation


protocol MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movies: [MovieModel], section: String)
    func didFailWithError(error: Error)
//    func didUpdateMovie(_ movieManager: MovieManager, movie: MovieModel)
}

struct MovieManager {

    let popularUrl = "https://api.themoviedb.org/3/movie/popular?language=en-US"
    let nowPlayingUrl = "https://api.themoviedb.org/3/movie/now_playing?language=en-US"
    let upcomingUrl = "https://api.themoviedb.org/3/movie/upcoming?language=en-US"
    let movieIDUrl = "https://api.themoviedb.org/3/movie/"
    
    let apiKey = "&api_key=" + "0cf52042cb11faab744bfbd7971b8f41"
    var delegate: MovieManagerDelegate?
    
//    func fetchMovieByID(id: String) {
//        let urlString = movieIDUrl + id + apiKey
//
//    }
    
    func fetchPopularMovie() {
        let urlString = popularUrl + apiKey
        
        performRequest(with: urlString, section: "popular")
    }
    
    func fetchNowPlayingMovie() {
        let urlString = nowPlayingUrl + apiKey
        
        performRequest(with: urlString, section: "nowPlaying")
    }

    func fetchUpcomingMovie() {
        let urlString = upcomingUrl + apiKey
        
        performRequest(with: urlString, section: "upcoming")
    }
    
    func performRequest(with urlString: String, section: String) {
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        let session = URLSession.shared
        
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                self.delegate?.didFailWithError(error: error!)
                return
            } else {
                if let safeData = data {
                    if let movieData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateMovie(self, movies: movieData, section: section)
                    }
                }
            }
        })
        
        dataTask.resume()
    }
    
    func parseJSON(_ movieData: Data) -> [MovieModel]? {
        let decoder = JSONDecoder()
        var movie: [MovieModel] = []
        do {
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            for i in 0..<decodedData.results.count {
                let title = decodedData.results[i].title
                let overview = decodedData.results[i].overview
                let poster_path = decodedData.results[i].poster_path
                let relase_date = decodedData.results[i].release_date
                let vote_average = decodedData.results[i].vote_average
                let genre_ids = decodedData.results[i].genre_ids
                movie.append(MovieModel(title: title, overview: overview, poster_path: poster_path, release_date: relase_date, vote_average: vote_average, genre_ids: genre_ids))
            }
            
            return movie
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

