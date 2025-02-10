import Foundation

class MoviesDescriptionInteractor: MoviesDescriptionInteractorProtocol {
    
    weak var presenter: MoviesDescriptionInteractorOutputProtocol?
    private let networkManager = NetworkManager.shared
    
    private let movie: MoviesDescription

    init(movie: MoviesDescription) {
        self.movie = movie
    }

    func fetchMovieDescription() {
        presenter?.didFetchMovie(movie)
    }

    func fetchPoster(from url: URL) {
        networkManager.fetchPoster(from: url) { [weak self] data in
            self?.presenter?.didFetchPoster(data)
        }
    }
}
