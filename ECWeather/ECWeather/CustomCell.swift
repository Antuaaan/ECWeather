//
//  CustomCell.swift
//  ECWeather
//
//  Created by Anton Mansvelt on 2017/05/18.
//  Copyright © 2017 Anton Mansvelt. All rights reserved.
//

import UIKit
class CustomCell : UITableViewCell {
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
