import UIKit

class MoviesViewController: UIViewController, UICollectionViewDelegateFlowLayout, MoviesViewProtocol {
    
    // MARK: - Private Properties
    private var presenter: MoviesPresenter!
    private let searchController = UISearchController(searchResultsController: nil)
    private var collectionView: UICollectionView!
    var dataSource: [Film] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.backgroundColor
        configure()
        presenter = MoviesPresenter(view: self)
        presenter.fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarController()
    }
    
    // MARK: - Private Methods
    private func configure() {
        checkAndRequestApiKey()
        setupNavBarController()
        setupSearchController()
        setupCollectionView()
    }
    
    func updateMovies(_ movies: [Film]) {
        dataSource = movies
        collectionView.reloadData()
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func navigateToMovieDescription(with description: MoviesDescription) {
        let descriptionVC = MoviesDescriptionViewController()
        descriptionVC.movieDescription = description
        navigationController?.pushViewController(descriptionVC, animated: true)
    }
    
    private func checkAndRequestApiKey() {
        guard KeychainManager.shared.retrieve(key: "apiKey") == nil else { return }
        showApiKeyAlert()
    }
    
    private func showApiKeyAlert() {
        let alert = UIAlertController(title: "API Key", message: "Введите ваш API ключ", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "API Key"
        }
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak self] _ in
            if let apiKey = alert.textFields?.first?.text, !apiKey.isEmpty {
                self?.presenter.setApiKey(apiKey)
                self?.presenter.fetchMovies()
            } else {
                self?.showApiKeyAlert()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 270)
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MoviesCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = Resources.Colors.backgroundColor
        self.view.addSubview(collectionView)
    }
    
    private func setupSearchController() {
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            let placeholderText = "Введите название фильма"
            
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
            searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
            
            searchTextField.textColor = UIColor.white
            
            searchTextField.tintColor = UIColor.white
        }
        
        if let searchIcon = searchController.searchBar.searchTextField.leftView as? UIImageView {
            searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
            searchIcon.tintColor = UIColor.white
        }
    }
    
    private func setupNavBarController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Resources.Colors.navBarColor
            
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MoviesCell else { return UICollectionViewCell() }
        cell.imageView.image = UIImage(systemName: "movieclapper")
        cell.imageView.tintColor = .lightGray
        cell.label.text = ""
        
        let film = dataSource[indexPath.row]
        cell.label.text = film.nameRU
        presenter.fetchPoster(for: film.posterURLPreview) { data in
            cell.imageView.image = data
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectMovie(at: indexPath.row)
    }
}
