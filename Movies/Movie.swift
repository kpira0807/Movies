import Foundation

struct Movie: Codable {
    let title: String?
    let homepage: String?
    let id: Int?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let backdrop_path: String?
    let production_companies: [Production_companies]
    let release_date: String?
    let tagline: String?
    let vote_average: Double?
    let status: String?
}

struct Production_companies: Codable {
    let name: String?
    let logo_path: String?
}
