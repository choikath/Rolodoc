//
//  EntityPickerViewController.swift
//  Rolodoc
//
//  Created by Katherine Choi on 4/30/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import UIKit

class EntityPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let defaults = UserDefaults.standard
    var entities: [String] = [String]()
    var hospitalSelected : String = "HUP"  // save settings into plist
    var indexSelected : Int = 0
    var delegate: HomeTableViewController?
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        entities = ["HUP", "PMC", "PAH", "VA"]
        
        
        if self.isKeyPresentInUserDefaults(key: "indexSelected") {
            pickerView.selectRow(defaults.integer(forKey: "indexSelected"), inComponent: 0, animated: false)
        }

        
//        pickerView.reloadAllComponents()
        popupView.layer.cornerRadius = 20
        popupView.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set up content vc for picking entity
    
   
    
    
    //construct alert window
   
    @IBAction func savePressed(_ sender: UIButton) {
        

        let indexSelected = pickerView.selectedRow(inComponent:0)
        let hospitalSelected = entities[indexSelected]
//        print("defaults in entity== \(defaults.string(forKey: "defaultHospital"))")
        
        defaults.set(hospitalSelected, forKey: "defaultHospital")
        defaults.set(indexSelected, forKey: "indexSelected")
        self.dismiss(animated: true) {
            self.delegate?.modalDismissed()
        }
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
   
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return entities.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        print(entities[row])
        return entities[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    

    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let color = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.blue : UIColor.black
//        return NSAttributedString(string: entities[row], attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: color])
//    }

}
