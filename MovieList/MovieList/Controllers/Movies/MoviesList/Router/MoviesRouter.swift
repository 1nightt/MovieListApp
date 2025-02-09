import Foundation
import UIKit

class MoviesRouter: MoviesViewRouterProtocol {

    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func createModule() -> UIViewController {
        let view = MoviesViewController()
        let interactor = MoviesInteractor()
        let router = MoviesRouter(viewController: view)
        let presenter = MoviesPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToMovieDetail(movie: MoviesDescription) {
        let descriptionVC = MoviesDescriptionViewController()
        descriptionVC.movieDescription = movie
        viewController?.navigationController?.pushViewController(descriptionVC, animated: true)
    }
    
}
