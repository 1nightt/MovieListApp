import UIKit

class MoviesDescriptionRouter: MoviesDescriptionRouterProtocol {
    
    weak var viewController: UIViewController?

    static func createModule(with movie: MoviesDescription) -> UIViewController {
        let view = MoviesDescriptionViewController()
        let interactor = MoviesDescriptionInteractor(movie: movie)
        let router = MoviesDescriptionRouter()
        let presenter = MoviesDescriptionPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
