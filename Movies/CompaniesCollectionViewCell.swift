import UIKit

class CompaniesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameCompaniMovies: UILabel!
    @IBOutlet weak var logoCompaniMovies: UIImageView!
    
    override func layoutSubviews() {
        logoCompaniMovies.layer.cornerRadius = 7
        logoCompaniMovies.layer.borderColor = UIColor.lightGreyNew.cgColor
        logoCompaniMovies.layer.borderWidth = 1
        logoCompaniMovies.clipsToBounds = true
        
    }
}
