import UIKit

class MoviesRouter: MoviesViewRouterProtocol {

    weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    static func createModule() -> UIViewController {
        let view = MoviesViewController()
        let interactor = MoviesInteractor()
        let router = MoviesRouter(viewController: view)
        let presenter = MoviesPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToMovieDetail(movie: MoviesDescription) {
        let descriptionVC = MoviesDescriptionRouter.createModule(with: movie)
        viewController?.navigationController?.pushViewController(descriptionVC, animated: true)
    }
}
