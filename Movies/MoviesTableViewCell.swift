import UIKit

class MoviesTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var imageMovies: UIImageView!
    @IBOutlet private weak var nameMovies: UILabel!
    @IBOutlet private weak var averageMovies: UILabel!
    @IBOutlet private weak var overviewMovies: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.secondarySystemBackground
        
        averageMovies.layer.backgroundColor = UIColor.systemGreenColor.cgColor
        averageMovies.clipsToBounds = true
    }
    
    func setup(with movie: Movies) {
        nameMovies.text = movie.title
        averageMovies.text = "\(movie.vote_average ?? 0)"
        overviewMovies.text = movie.overview
        
        let urls = URL(string:"https://image.tmdb.org/t/p/w400" + (movie.poster_path ?? ""))
        
        if let data = try? Data(contentsOf: urls!)
        {
            let image: UIImage = UIImage(data: data)!
            imageMovies.image = image
        }   
    }
}
