import Foundation

struct AllMovies: Codable{
    let page : Int?
    let results : [Movies]
    let total_pages : Int?
    let total_results : Int?
    
    enum MoviesKeys: String, CodingKey {
        case page
        case results
        case total_pages
        case total_results
    }
}

struct Movies: Codable {
    let original_title: String?
    let id: Int?
    let title: String?
    let vote_average: Double?
    let overview: String?
    let poster_path: String?
    let release_date: String?
    let backdrop_path: String?
    let popularity: Double?
}
