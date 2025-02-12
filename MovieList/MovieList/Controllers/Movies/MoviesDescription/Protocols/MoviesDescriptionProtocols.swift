import UIKit

protocol MoviesDescriptionViewProtocol: AnyObject {
    func updateView(with movie: MoviesDescription)
    func updatePoster(with imageData: Data)
}

protocol MoviesDescriptionPresenterProtocol: AnyObject {
    func loadData()
    func backButtonTapped()
    
    func didFetchMovie(_ movie: MoviesDescription)
    func didFetchPoster(_ data: Data)
}

protocol MoviesDescriptionInteractorProtocol {
    var presenter: MoviesDescriptionPresenterProtocol? { get set }
    func fetchMovieDescription()
    func fetchPoster(from url: URL)
}

protocol MoviesDescriptionRouterProtocol {
    func navigateBack()
}
