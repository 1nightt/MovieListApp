import UIKit

protocol MoviesDescriptionViewProtocol: AnyObject {
    func updateView(with movie: MoviesDescription)
    func updatePoster(with imageData: Data)
}

protocol MoviesDescriptionPresenterProtocol {
    func loadData()
    func backButtonTapped()
}

protocol MoviesDescriptionInteractorProtocol {
    func fetchMovieDescription()
    func fetchPoster(from url: URL)
}

protocol MoviesDescriptionInteractorOutputProtocol: AnyObject {
    func didFetchMovie(_ movie: MoviesDescription)
    func didFetchPoster(_ data: Data)
}

protocol MoviesDescriptionRouterProtocol {
    func navigateBack()
}
