//
//  BusinessCell.swift
//  Yelp
//
//  Created by datdn1 on 9/3/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var positionOnTableView:Int!
    
    var business:Business!{
        didSet{
            self.nameLabel.text = "\(positionOnTableView!).\(business.name!)"
            self.thumbImageView.setImageWithURL(business.imageURL)
            self.distanceLabel.text = business.distance
            self.ratingImageView.setImageWithURL(business.ratingImageURL)
            self.reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            self.addressLabel.text = business.address
            self.categoriesLabel.text = business.categories
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbImageView.layer.cornerRadius = 5
        self.thumbImageView.clipsToBounds = true
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.width
        self.distanceLabel.preferredMaxLayoutWidth = self.distanceLabel.frame.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.width
        self.distanceLabel.preferredMaxLayoutWidth = self.distanceLabel.frame.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
