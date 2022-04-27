//
//  MagnetReviewCell.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/26.
//

import UIKit

class MagnetReviewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        attribute()
    }
    
    private func attribute() {
        self.selectionStyle = .none
    }
    
    func setData(data: ReviewItem) {
        self.nameLabel.text = data.userId
        self.ratingLabel.text = setStar(rating: data.rating)
        self.dateLabel.text = "오늘"
        self.photoImageView.image = UIImage(named: "space_bread1.jpeg")
        photoImageView.contentMode = .scaleAspectFill
        self.reviewLabel.text = data.description
        self.reviewLabel.numberOfLines = 0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setStar(rating: Int = 5) -> String {
        let totalRating:String = {
            switch rating {
            case 0:
                return "☆☆☆☆☆"
            case 1:
                return "★☆☆☆☆"
            case 2:
                return "★★☆☆☆"
            case 3:
                return "★★★☆☆"
            case 4:
                return "★★★★☆"
            case 5:
                return "★★★★★"
            default:
                return "☆☆☆☆☆"
            }
        }()
        return totalRating
    }
}

