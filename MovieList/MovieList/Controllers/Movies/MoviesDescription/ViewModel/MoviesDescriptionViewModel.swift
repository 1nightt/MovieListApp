import Foundation

class MoviesDescriptionViewModel {
    
    // MARK: - Private Properties
    
    private let newtworkManager = NetworkManager.shared
    
    // MARK: - Public Properties
    
    var moviesDescription: MoviesDescription
    var onDescriptionLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initializers
    
    init(movie: MoviesDescription) {
        self.moviesDescription = movie
    }
    
    var movieTitle: String {
        moviesDescription.nameRU
    }
    
    var movieYear: Int {
        moviesDescription.year
    }
    
    var movieRating: String {
        String(moviesDescription.ratingKinopoisk)
    }
    
    var movieGenres: String {
        moviesDescription.genres.map { $0.genre }.joined(separator: ", ")
    }
    
    var movieDescription: String {
        moviesDescription.description
    }
    
    // MARK: - Public Methods
    
    func fetchMoviesDescription(for filmId: String) {
        newtworkManager.fetchDescriptionMovies(for: filmId) { [weak self] result in
            switch result {
            case .success(let moviesDescription):
                self?.moviesDescription = moviesDescription
                self?.onDescriptionLoaded?()
            case .failure(let error):
                self?.onError?((error.localizedDescription))
            }
        }
    }
    
    func loadPoster(completion: @escaping (Data) -> Void) {
        newtworkManager.fetchPoster(from: moviesDescription.posterURL) { data in
            completion(data)
        }
    }
}
