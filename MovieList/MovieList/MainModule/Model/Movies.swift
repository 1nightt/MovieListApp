import Foundation

struct Movies: Codable {
    let films: [Film]
}

struct Film: Codable {
    let filmID: Int
    let nameRU: String
    let posterURLPreview: URL
    
    enum CodingKeys: String, CodingKey {
        case filmID = "filmId"
        case nameRU = "nameRu"
        case posterURLPreview = "posterUrlPreview"
    }
}

struct MoviesDescription: Codable {
    let kinopoiskID: Int
    let nameRU: String
    let posterURL: URL
    let ratingKinopoisk: Double
    let year: Int
    let description: String
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case kinopoiskID = "kinopoiskId"
        case nameRU = "nameRu"
        case posterURL = "posterUrl"
        case ratingKinopoisk
        case year
        case description
        case genres
    }
    
}

struct Genre: Codable {
    let genre: String
}
