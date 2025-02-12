import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private var apiKey: String? {
        return KeychainManager.shared.retrieve(key: "apiKey")
    }
    
    private init() {}
    
    func setApiKey(_ key: String) {
        let success = KeychainManager.shared.save(key: "apiKey", value: key)
        print(success ? "API key saved successfully" : "Failed to save API key")
    }

    func fetchPoster(from url: URL, completion: @escaping (Data) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("Failed to load poster: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchMovies(page: Int, completion: @escaping (Result<Movies, AFError>) -> Void) {
        guard let apiKey = self.apiKey else {
            print("API key not set")
            return
        }
        
        let parameters: [String: String] = ["page": "\(page)"]
        
        AF.request(Link.allMovies.url, parameters: parameters, headers: ["X-API-KEY": apiKey])
            .validate()
            .responseDecodable(of: Movies.self) { response in
                switch response.result {
                case .success(let movies):
                    completion(.success(movies))
                case .failure(let error):
                    print("Error fetching movies: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }

    func fetchAllMovies(completion: @escaping (Result<[Film], AFError>) -> Void) {
        var allMovies: [Film] = []
        var currentPage = 1
        let dispatchGroup = DispatchGroup()

        func loadPage(page: Int) {
            dispatchGroup.enter()
            fetchMovies(page: page) { result in
                switch result {
                case .success(let movies):
                    allMovies.append(contentsOf: movies.films)
                    if page < movies.pagesCount {
                        currentPage += 1
                        loadPage(page: currentPage)
                    }
                case .failure(let error):
                    print("Error fetching page \(page): \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }

        loadPage(page: currentPage)

        dispatchGroup.notify(queue: .main) {
            completion(.success(allMovies))
        }
    }

    func fetchDescriptionMovies(for filmId: String, completion: @escaping (Result<MoviesDescription, AFError>) -> Void) {
        guard let apiKey = self.apiKey else {
            print("API key not set")
            return
        }

        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(filmId)"
        
        AF.request(urlString, headers: ["X-API-KEY": apiKey])
            .validate()
            .responseDecodable(of: MoviesDescription.self) { response in
                switch response.result {
                case .success(let movieDescription):
                    completion(.success(movieDescription))
                case .failure(let error):
                    print("Error fetching movie description: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}

// MARK: - API Links

extension NetworkManager {
    enum Link {
        case allMovies

        var url: URL {
            switch self {
            case .allMovies:
                return URL(string: "https://kinopoiskapiunofficial.tech/api/v2.2/films/top")!
            }
        }
    }
}
