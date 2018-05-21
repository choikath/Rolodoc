//
//  ProfileFieldCell.swift
//  Rolodoc
//
//  Created by Katherine Choi on 4/29/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//
import UIKit
//import Former

class ProfileFieldCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var consultLabel: UILabel!
    @IBOutlet weak var consultText: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        consultText.text = "Ask a question"
        consultText.textColor = UIColor.lightGray

    func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
}
