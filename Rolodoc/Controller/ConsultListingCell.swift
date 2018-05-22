//
//  ConsultListingCell.swift
//  Rolodoc
//
//  Created by Katherine Choi on 5/21/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import UIKit
import SwipeCellKit

class ConsultListingCell:  SwipeTableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var descrip: UILabel!

    
//    var delegate: SwipeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
