//
//  CitiesTableViewCell.swift
//  DemoApp
//
//  Created by  Harsh Saxena on 15/05/19.
//  Copyright © 2019  Harsh Saxena. All rights reserved.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
