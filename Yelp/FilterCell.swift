//
//  FilterCell.swift
//  Yelp
//
//  Created by datdn1 on 9/4/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
