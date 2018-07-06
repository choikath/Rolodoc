//
//  CheckboxButton.swift
//  Rolodoc
//
//  Created by Katherine Choi on 7/2/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import UIKit

class CheckboxButton: UIButton {

    // Images
    let checkedImage = UIImage(named: "checkbox")! as UIImage
    let uncheckedImage = UIImage(named: "checkbox-outline")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
                self.setTitleColor(UIColor.black, for: UIControlState.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
                self.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            }
        }
    }
    
    weak var delegate: ProfileFieldCell? // to pass checked state to textpage modal
    
    override func awakeFromNib() {
//        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
        self.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        
    }
    
//    @objc func buttonClicked(sender: UIButton) {
//        if sender == self {
//            isChecked = !isChecked
//            delegate?.puppyGiphyClicked()
//            print("original button clicked")
//        }
//    }


}
