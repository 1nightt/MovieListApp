import UIKit

class MoviesViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Private Properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = MoviesViewModel()
    
    private var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.backgroundColor
        configure()
        navigationController?.navigationBar.sizeToFit()
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
        setupDismissKeyboardGesture()
        bindViewModel()
        viewModel.fetchMovies()
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
                self?.viewModel.networkManager.setApiKey(apiKey)
                self?.bindViewModel()
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
        searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            let placeholderText = "Введите название фильма"
            
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
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
        navigationController?.navigationBar.isTranslucent = false
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
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.onMovieDescriptionLoaded = { [weak self] movieDescription in
            DispatchQueue.main.async {
                self?.navigateToMovieDescriptionViewController(with: movieDescription)
            }
        }
        
        viewModel.onError = { errorMessage in
            print("Ошибка: \(errorMessage)")
        }
    }
    
    @objc private func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Public Methods
    
    func navigateToMovieDescriptionViewController(with movieDescription: MoviesDescription) {
        let viewModel = MoviesDescriptionViewModel(movie: movieDescription)
        let descriptionVC = MoviesDescriptionViewController(viewModel: viewModel)
        navigationController?.pushViewController(descriptionVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MoviesCell else { return UICollectionViewCell() }
        cell.imageView.image = UIImage(systemName: "movieclapper")
        cell.imageView.tintColor = .lightGray
        cell.label.text = ""
        
        let film = viewModel.filteredMovies[indexPath.row]
        cell.label.text = film.nameRU
        
        viewModel.fetchPoster(for: film.posterURLPreview) { data in
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: data)
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let film = viewModel.filteredMovies[indexPath.row]
        
        viewModel.fetchMovieDescription(for: String(film.filmID))
    }
}

// MARK: - UISearchResultsUpdating

extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterMovies(with: searchController.searchBar.text ?? "")
    }
}

// MARK: - UIScrollViewDelegate

extension MoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let offset = scrollView.contentOffset.y
        let alpha = 1 - (offset / 100)
        navigationBar.alpha = max(1, min(1, alpha))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}

// MARK: - Extensions

extension MoviesViewController {
    func scrollToTop() {
        guard !viewModel.dataSource.isEmpty else { return }
        
        let topOffset = CGPoint(x: 0, y: -collectionView.adjustedContentInset.top)
        
        collectionView.setContentOffset(topOffset, animated: true)
    }
}
