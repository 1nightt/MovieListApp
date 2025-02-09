import Foundation
import UIKit

class MoviesInteractor: MoviesViewInteractorProtocol {
    
    weak var presenter: MoviesViewInteractorOutputProtocol?
    
    func fetchPoster(for url: URL, completion: @escaping (Data) -> Void) {
        NetworkManager.shared.fetchPoster(from: url) { data in
            completion(data)
        }
    }
    
    func fetchMovies() {
        NetworkManager.shared.fetchAllMovies { [ weak self ] result in
            switch result {
            case .success(let movies):
                self?.presenter?.moviesFetched(movies)
            case .failure(let error):
                self?.presenter?.moviesFetchFailed(error: error.localizedDescription)
            }
        }
    }
    
    func fetchMovieDescription(for filmId: String) {
        NetworkManager.shared.fetchDescriptionMovies(for: filmId) { [ weak self ] result in
            switch result {
            case .success(let movieDescription):
                self?.presenter?.movieDescriptionFetched(movieDescription)
            case .failure(let error):
                self?.presenter?.movieDescriptionFetchFailed(error: error.localizedDescription)
            }
        }
    }
    
}
