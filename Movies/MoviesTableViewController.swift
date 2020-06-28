import UIKit
import Foundation

class MoviesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // Search bar
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredMovies = [Movies]()
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        let movie = movies
        filteredMovies = movie.filter({( movie : Movies) -> Bool in
            return movie.title!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    var movies = [Movies]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(page: pageNumber)
        
        // Search bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        self.definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Table view data source
    
    private var pageNumber: Int = 1 // for pagination with JSON more then 1 pages
    private var isLoading = false
    
    func getData(page: Int) {
        
        activityIndicator.startAnimating()
        
        let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=4e016f5d37a15856e5af35bc4eaf10a6&page=\(page)")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                
                let movie = try decoder.decode(AllMovies.self, from: data).results
                //self.movies.insert(contentsOf: movie, at: 0)
                
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.isLoading = false
                    self.activityIndicator.stopAnimating()
                    self.movies.append(contentsOf: movie)
                    self.tableView.reloadData()
                    
                }
            } catch {
                self.showError()
                self.activityIndicator.stopAnimating()
            }
            
        }.resume()
    }
    
    private func loadMore() {
        guard !isLoading else { return }
        isLoading = true
        pageNumber += 1
        getData(page: pageNumber)
    }
    
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredMovies.count
        }
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "moviesTableViewCell", for: indexPath) as? MoviesTableViewCell
            else {
                return UITableViewCell()
        }
        
        if indexPath.row == movies.count - 1 {
            loadMore()
        }
        
        var movie: Movies
        if isFiltering() {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        cell.setup(with: movie)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreInfo" {
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return }
            let movie = movies[indexPath.row]
            if let  movieViewController: MovieViewController = segue.destination as? MovieViewController {
                movieViewController.movie = movie
            }
        }
    }
}
