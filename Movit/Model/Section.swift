import Foundation

enum Section {
    case popular([MovieModel])
    case nowPlaying([MovieModel])
    case upcoming([MovieModel])
    
    var movies: [MovieModel] {
        switch self {
        case .nowPlaying(let movies),
                .popular(let movies),
                .upcoming(let movies):
            return movies
        }
    }
    
    var count: Int {
        return movies.count
    }
    var title: String {
        switch self {
        case .nowPlaying:
            return "Now playing"
        case .popular:
            return "Popular"
        case .upcoming:
            return "Coming Soon"
        }
    }
}


