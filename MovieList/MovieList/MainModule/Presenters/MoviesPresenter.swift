import Foundation
import UIKit

protocol MoviesPresenterProtocol: AnyObject {
    func fetchMovies()
    func fetchPoster(for url: URL, completion: @escaping (UIImage?) -> Void)
    func didSelectMovie(at index: Int)
    func setApiKey(_ key: String)
}

protocol MoviesViewProtocol: AnyObject {
    func updateMovies(_ movies: [Film])
    func showError(_ error: String)
    func navigateToMovieDescription(with description: MoviesDescription)
}

class MoviesPresenter {
    weak private var view: MoviesViewProtocol?
    private let networkManager: NetworkManager
    private var movies: [Film] = []
    
    init(view: MoviesViewProtocol? = nil, networkManager: NetworkManager = NetworkManager.shared) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func fetchMovies() {
        networkManager.fetchMovies { [weak self] result in
            switch result {
            case .success(let moviesResponse):
                self?.movies = moviesResponse.films
                self?.view?.updateMovies(moviesResponse.films)
            case .failure(let error):
                self?.view?.showError("Failed to load movies: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPoster(for url: URL, completion: @escaping (UIImage?) -> Void) {
        networkManager.fetchPoster(from: url) { data in
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    func didSelectMovie(at index: Int) {
        guard index < movies.count else { return }
        let selectedMovie = movies[index]
        
        networkManager.fetchDescriptionMovies(for: String(selectedMovie.filmID)) { [weak self] result in
            switch result {
            case .success(let movieDescription):
                self?.view?.navigateToMovieDescription(with: movieDescription)
            case .failure(let error):
                self?.view?.showError("Failed to fetch movie description: \(error.localizedDescription)")
            }
        }
    }
    
    func setApiKey(_ key: String) {
        let success = KeychainManager.shared.save(key: "apiKey", value: key)
        if success {
            print("API key saved successfully")
        } else {
            view?.showError("Failed to save API key")
        }
    }
}
