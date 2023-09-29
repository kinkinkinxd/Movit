import Foundation
import RealmSwift

class GenreWrapper: Object {
    @objc dynamic var value: Int = 0
    var parentMovie = LinkingObjects(fromType: MovieModel.self, property: "genreList")
}
class MovieModel: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var poster_path: String = ""
    @objc dynamic var release_date: String = ""
    @objc dynamic var vote_average: Double = 0.0
    var genreList = List<GenreWrapper>()
    var genre_ids: [Int] = []
    
    
    convenience init(title: String, overview: String, poster_path: String,
                     release_date: String, vote_average: Double, genre_ids: [Int]) {
        self.init()
        self.title = title
        self.overview = overview
        self.poster_path = poster_path
        self.release_date = release_date
        self.vote_average = vote_average
        self.genre_ids = genre_ids
        genre_ids.forEach { genreID in
            let genreWrapper = GenreWrapper()
            genreWrapper.value = genreID
            genreList.append(genreWrapper)
        }
       }
    
    func getPosterPath() -> String {
        return "https://image.tmdb.org/t/p/original" + poster_path
    }
    
    func getVoteAverage() -> Double {
        let rescale: Double = round(vote_average) / 2
        return rescale
    }
    
    
}
