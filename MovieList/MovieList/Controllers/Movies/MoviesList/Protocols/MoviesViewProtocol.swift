import UIKit

protocol MoviesViewProtocol: AnyObject {
    func showMovies(_ movies: [Film])
    func showError(_ error: String)
    func showApiKeyAlert()
}

protocol MoviesViewPresenterProtocol: AnyObject {
    func loadData()
    func searchMovies(with query: String)
    func didSelectedMovie(_ movie: Film)
    func requesApiKeyIfNeeded()
    func fetchPoster(for url: URL, completion: @escaping (Data) -> Void)
}

protocol MoviesViewInteractorProtocol: AnyObject {
    func fetchPoster(for url: URL, completion: @escaping (Data) -> Void)
    func fetchMovies()
    func fetchMovieDescription(for filmId: String)
}

protocol MoviesViewInteractorOutputProtocol: AnyObject {
    func moviesFetched(_ movies: [Film])
    func moviesFetchFailed(error: String)
    func movieDescriptionFetched(_ description: MoviesDescription)
    func movieDescriptionFetchFailed(error: String)
}

protocol MoviesViewRouterProtocol: AnyObject {
    func navigateToMovieDetail(movie: MoviesDescription)
}
