import UIKit

protocol MoviesDescriptionViewProtocol: AnyObject {
    func displayPoster(image: UIImage?)
    func displayError(message: String)
}

class MoviesDescriptionPresenter {
    
    weak var view: MoviesDescriptionViewProtocol?
    private let networkManager: NetworkManager
    private let movieDescription: MoviesDescription
    
    init(view: MoviesDescriptionViewProtocol,
         networkManager: NetworkManager = .shared,
         movieDescription: MoviesDescription) {
        self.view = view
        self.networkManager = networkManager
        self.movieDescription = movieDescription
    }
    
    func fetchPosterImage() {
        networkManager.fetchPoster(from: movieDescription.posterURL) { [weak self] data in
            guard let image = UIImage(data: data) else {
                self?.view?.displayError(message: "Failed to load poster image.")
                return
            }
            self?.view?.displayPoster(image: image)
        }
    }
}
