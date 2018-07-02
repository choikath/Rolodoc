//
//  ProfileFieldCell.swift
//  Rolodoc
//
//  Created by Katherine Choi on 4/29/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//
import UIKit
//import Former

class ProfileFieldCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var consultLabel: UILabel!
    @IBOutlet weak var consultText: UITextView!
    
    weak var delegate: TextPageViewController?
    
//    var buttonAction: ((Any) -> Void)?
//    
//    @objc func buttonPressed(sender: Any) {
//        self.buttonAction?(sender)
//    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        consultText.text = "Ask a question"
        consultText.textColor = UIColor.lightGray

        func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        textField.delegate = self
        textField.addTarget(self, action: #selector(didChangeText(_:)), for: UIControlEvents.editingChanged)
        consultText.delegate = self
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        delegate?.didEndEditing(onCell: self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didEndEditing(onCell: self)
    }
    
    @objc func didChangeText(_ textField: UITextField) {
        delegate?.didEndEditing(onCell: self)
    }
    
    
    
    
    
}
