import UIKit

class MoviesDescriptionPresenter: MoviesDescriptionPresenterProtocol {

    
    weak var view: MoviesDescriptionViewProtocol?
    var interactor: MoviesDescriptionInteractorProtocol?
    var router: MoviesDescriptionRouterProtocol?
    
    init(view: MoviesDescriptionViewProtocol, interactor: MoviesDescriptionInteractorProtocol, router: MoviesDescriptionRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func loadData() {
        interactor?.fetchMovieDescription()
    }

    func backButtonTapped() {
        router?.navigateBack()
    }
}

extension MoviesDescriptionPresenter: MoviesDescriptionInteractorOutputProtocol {
    func didFetchMovie(_ movie: MoviesDescription) {
        view?.updateView(with: movie)
        interactor?.fetchPoster(from: movie.posterURL)
    }

    func didFetchPoster(_ data: Data) {
        view?.updatePoster(with: data)
    }
}
