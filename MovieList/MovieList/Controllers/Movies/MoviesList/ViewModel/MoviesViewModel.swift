import Foundation

class MoviesViewModel {
    
    // MARK: - Private Properties
    
    let networkManager = NetworkManager.shared
    
    // MARK: - Public Properties
    
    var dataSource = [Film]()
    var filteredMovies = [Film]()
    
    var onMoviesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onMovieDescriptionLoaded: ((MoviesDescription) -> Void)?
    
    // MARK: - Public Methods
    
    func fetchMovies() {
        networkManager.fetchAllMovies { [ weak self ] result  in
            switch result {
            case .success(let movies):
                self?.dataSource = movies
                self?.filteredMovies = movies
                self?.onMoviesUpdated?()
            case .failure(let error):
                print("Error in fetchAllMovies: \(error.localizedDescription)")
                self?.onError?((error.localizedDescription))
            }
        }
    }
    
    func fetchPoster(for URL: URL, completion: @escaping (Data) -> Void) {
        networkManager.fetchPoster(from: URL, completion: completion)
    }
    
    func fetchMovieDescription(for filmId: String) {
        networkManager.fetchDescriptionMovies(for: filmId) { [weak self] result in
            switch result {
            case .success(let movieDescription):
                self?.onMovieDescriptionLoaded?(movieDescription)
            case .failure(let error):
                self?.onError?("Error fetching movie description: \(error.localizedDescription)")
                
            }
        }
    }
    
    func filterMovies(with searchText: String) {
        if searchText.isEmpty {
            filteredMovies = dataSource
        } else {
            filteredMovies = dataSource.filter { $0.nameRU.lowercased().contains(searchText.lowercased()) }
        }
        onMoviesUpdated?()
    }
    
}
