//
//  CenterLabelCell.swift
//  Rolodoc
//
//  Created by Katherine Choi on 4/29/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//
import UIKit
//import Former

//final class CenterLabelCell: FormCell, LabelFormableRow {
//

class CenterLabelCell: UITableViewCell {

    
    @IBOutlet weak var consultType: UISegmentedControl!
    
    @IBAction func consultTypeSelected(_ sender: UISegmentedControl) {
        print("# of segments = \(sender.numberOfSegments)")
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("new consult selected")
        case 1:
            print("follow-up selected")
        default:
            break;
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
        
        
    }

    
}
