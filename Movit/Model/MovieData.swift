import Foundation

struct MovieData: Codable {
    let results: [Results]
}

struct Results: Codable {
    let title: String
    let overview: String
    let poster_path: String
    let release_date: String
    let vote_average: Double
    let genre_ids: [Int]
}
