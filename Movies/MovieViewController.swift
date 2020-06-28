import UIKit
import Foundation

class MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieAbout?.production_companies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompaniesCollectionViewCell", for: indexPath) as?   CompaniesCollectionViewCell
            else {
                return UICollectionViewCell()
        }
        let company = movieAbout?.production_companies[indexPath.row]
        cell.nameCompaniMovies.text = company?.name ?? "No information"
        
        let urls = URL(string:"https://image.tmdb.org/t/p/w400" + (company?.logo_path ?? "/kqjL17yufvn9OVLyXYpvtyrFfak.jpg"))
        if let data = try? Data(contentsOf: urls!)
        {
            let image: UIImage = UIImage(data: data)!
            cell.logoCompaniMovies.image = image
        }
        return cell
    }
    
    
    var movie: Movies?
    
    @IBOutlet private weak var nameMovies: UILabel!
    @IBOutlet private weak var averageMovies: UILabel!
    @IBOutlet private weak var imageMovies: UIImageView!
    @IBOutlet private weak var aboutMovies: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var releaseDate: UILabel!
    @IBOutlet private weak var popular: UILabel!
    @IBOutlet private weak var taglineLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var homepageButton: UIButton!
    @IBOutlet  weak var collectionView: UICollectionView!
    
    var movieAbout: Movie?
    
    @IBAction func homepageButton(_ sender: Any) {
        
        if let url = URL(string: movieAbout?.homepage ?? "https://www.wikipedia.org") {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        homepageButton.backgroundColor = UIColor.skyBlue
        homepageButton.layer.cornerRadius = 7
        homepageButton.layer.borderColor = UIColor.lemonColor.cgColor
        homepageButton.layer.borderWidth = 1
        homepageButton.clipsToBounds = true
        
        averageMovies.layer.backgroundColor = UIColor.systemGreenColor.cgColor
        averageMovies.clipsToBounds = true
        
        let dateString = movie?.release_date as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateStyle = .medium
        releaseDate.text = dateFormatter.string(from: date!)
        
        let movie_id = movie?.id
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie_id ?? 1)?api_key=4e016f5d37a15856e5af35bc4eaf10a6&language=en-US")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                
                self.movieAbout = try decoder.decode(Movie.self, from: data)
                
                DispatchQueue.main.async {
                    self.nameMovies.text = self.movieAbout?.title
                    self.averageMovies.text = "\(self.movieAbout?.vote_average ?? 0.0)"
                    self.aboutMovies.text = self.movieAbout?.overview
                    self.popular.text = "\(self.movieAbout?.popularity ?? 0.0)"
                    self.taglineLabel.text = self.movieAbout?.tagline
                    self.statusLabel.text = self.movieAbout?.status
                    
                    let urls = URL(string:"https://image.tmdb.org/t/p/w400" + (self.movieAbout?.backdrop_path ?? ""))
                    if let data = try? Data(contentsOf: urls!)
                    {
                        let image: UIImage = UIImage(data: data)!
                        self.imageMovies.image = image
                    }
                    
                }
            } catch {
                self.showError()
            }
            
        }.resume()
    }
    
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "Please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
}
