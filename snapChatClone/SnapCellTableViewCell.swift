//
//  SnapCellTableViewCell.swift
//  snapChatClone
//
//  Created by Shannon Armon on 1/10/16.
//  Copyright © 2016 RarefiedProudctions,LLC. All rights reserved.
//

import UIKit

class SnapCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userTextLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
