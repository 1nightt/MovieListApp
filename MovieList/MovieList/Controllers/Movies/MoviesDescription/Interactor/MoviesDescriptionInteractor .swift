import Foundation

class MoviesDescriptionInteractor: MoviesDescriptionInteractorProtocol {
    
    var presenter: MoviesDescriptionPresenterProtocol?
    private let networkManager = NetworkManager.shared
    private let movie: MoviesDescription

    init(movie: MoviesDescription) {
        self.movie = movie
    }

    func fetchMovieDescription() {
        presenter?.didFetchMovie(movie)
        fetchPoster(from: movie.posterURL)
    }

    func fetchPoster(from url: URL) {
        networkManager.fetchPoster(from: url) { [weak self] data in
            self?.presenter?.didFetchPoster(data)
        }
    }
}
