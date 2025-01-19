import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        delegate = self
    }
    
    private func configure() {
        let moviesViewController = MoviesViewController()
        let favoriteViewController = FavoriteViewController()
        
        tabBar.barStyle = .black
        tabBar.tintColor = Resources.Colors.active
        tabBar.unselectedItemTintColor = Resources.Colors.inactive
        tabBar.backgroundColor = Resources.Colors.tabBarColor
        
        moviesViewController.tabBarItem.image = Resources.Strings.Images.movies
        favoriteViewController.tabBarItem.image = Resources.Strings.Images.favorite
        
        moviesViewController.title = Resources.Strings.TabBar.movies
        favoriteViewController.title = Resources.Strings.TabBar.favorite
        
        let moviesNavViewController = UINavigationController(rootViewController: moviesViewController)
        
        setViewControllers([moviesNavViewController, favoriteViewController], animated: true)
    }
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let navigationController = viewController as? UINavigationController,
           let moviesViewController = navigationController.viewControllers.first as? MoviesViewController,
           viewController == selectedViewController {
            // Прокрутка вверх, если MoviesViewController уже выбран
            moviesViewController.scrollToTop()
        }
        return true
    }
}
