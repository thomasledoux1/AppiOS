//
//  TaskTableViewCell.swift
//  NewApp
//
//  Created by Thomas on 03/01/2017.
//  Copyright © 2017 Thomas. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    //Properties
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var importanceLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
            }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
