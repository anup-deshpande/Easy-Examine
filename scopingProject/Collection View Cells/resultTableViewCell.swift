//
//  resultTableViewCell.swift
//  scopingProject
//
//  Created by Anup Deshpande on 11/13/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit

class resultTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
