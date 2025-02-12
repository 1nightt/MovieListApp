import Foundation

class MoviesPresenter: MoviesViewPresenterProtocol {
    
    weak var view: MoviesViewProtocol?
    var interactor: MoviesViewInteractorProtocol?
    var router: MoviesViewRouterProtocol?
    
    private var allMovies: [Film] = []
    
    init(view: MoviesViewProtocol, interactor: MoviesViewInteractorProtocol, router: MoviesViewRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func loadData() {
        requesApiKeyIfNeeded()
        interactor?.fetchMovies()
    }
    
    func searchMovies(with query: String) {
        if query.isEmpty {
            view?.showMovies(allMovies)
        } else {
            let filteredMovies = allMovies.filter { $0.nameRU.lowercased().contains(query.lowercased()) }
            view?.showMovies(filteredMovies)
        }
    }
    
    func didSelectedMovie(_ movie: Film) {
        interactor?.fetchMovieDescription(for: String(movie.filmID))
    }
    
    func requesApiKeyIfNeeded() {
        if KeychainManager.shared.retrieve(key: "apiKey") == nil {
            view?.showApiKeyAlert()
        }
    }
    
    func fetchPoster(for url: URL, completion: @escaping (Data) -> Void) {
        interactor?.fetchPoster(for: url, completion: completion)
    }
    
    func moviesFetched(_ movies: [Film]) {
        self.allMovies = movies
        view?.showMovies(movies)
    }
    
    func moviesFetchFailed(error: String) {
        view?.showError(error)
    }
    
    func movieDescriptionFetched(_ description: MoviesDescription) {
        router?.navigateToMovieDetail(movie: description)
    }
    
    func movieDescriptionFetchFailed(error: String) {
        view?.showError(error)
    }
}
